# == Schema Information
# Schema version: 20100727173851
#
# Table name: staging_areas
#
#  id                      :integer         primary key
#  name                    :string(255)
#  staging_area_company_id :integer
#  contact                 :string(255)
#  address                 :string(255)
#  city                    :string(255)
#  phone                   :string(255)
#  fax                     :string(255)
#  state                   :string(255)
#  zip                     :string(255)
#  email                   :string(255)
#  lat                     :decimal(, )
#  lon                     :decimal(, )
#  access_id               :integer
#  icon                    :string(255)
#

require 'nokogiri'

class StagingArea < ActiveRecord::Base
  belongs_to :staging_area_company
  has_many :staging_area_assets, :dependent => :destroy
  has_many :staging_area_details, :dependent => :destroy

  include Backburner::Performable


  def self.parse_uploads(params)
    sa = StagingAreaCompany.find_by_id(params[:company_id])
    sa.update_attribute(:title, params[:company_title]) if params[:company_title] 
    sa.layer.update_attribute(:title, params[:layer_title]) if params[:layer_title]
    sa.layer.update_attribute(:icon, params[:layer_icon]) if params[:layer_icon]

    locationsFile = File.read(params[:map_locations].path)

    raise Exception('Attempted to parse an empty string') unless locationsFile.length > 0

    begin
      # Get the contents and construct Nokogiri instance
      locations = Nokogiri::XML(locationsFile) do |config|
        config.noblanks
      end

      # Verify contents
      required_fields = ['LocationCode', 'LocationName', 'Latitude', 'Longitude']
      self.check_existence_of(required_fields, locations, locationsFile.original_filename)

      # Apply an XML transformation
      xslt = Nokogiri::XSLT(File.read('ddscripts/staging_areas/Map_Locations.xsl'))
      locations = xslt.transform(locations)
    rescue Nokogiri::XML::SyntaxError => e
      return e.message
    rescue Exception => e
      return e.message
    end


    # Parse XML and apply transformations
    begin   
      # Note: Nokogiri returns a parse error for XML with non-unicode characters when in strict mode. Strict mode temporarily turned off.
      if params[:map_assets] # force replacement of non-unicode characters
        doc           = Nokogiri::XML(File.read(params[:map_assets].path).encode!('UTF-8', 'UTF-8', :invalid => :replace)) { |config| config.noblanks }
        self.check_existence_of(["Ident", "LocationCode", "AssetTypeCode", "MapAsset"], doc, "Map Assets")
        xslt          = Nokogiri::XSLT(File.read("ddscripts/staging_areas/Map_Assets.xsl"))
        assets_doc    = xslt.transform(doc)
      end

      if params[:map_asset_types]
        doc           = Nokogiri::XML(File.read(params[:map_asset_types].path).encode!('UTF-8', 'UTF-8', :invalid => :replace)) { |config| config.noblanks }
        self.check_existence_of(["AssetTypeCode", "AssetTypeName"], doc, "Map Asset Types")
        xslt          = Nokogiri::XSLT(File.read("ddscripts/staging_areas/Map_Asset_Types.xsl"))
        types_doc     = xslt.transform(doc)
      end

      doc  = Nokogiri::XML(File.read(params[:map_locations].path).encode!('UTF-8', 'UTF-8', :invalid => :replace)) { |config| config.noblanks }

      self.check_existence_of(["LocationCode", "LocationName", "Latitude", "Longitude"], doc, "Map Locations")

    rescue Nokogiri::XML::SyntaxError => e
      return e.message
    rescue Exception => e
      return e.message
    end

    if (params.has_key?(:map_asset_types) && params.has_key?(:map_assets))
      # use delayed job to process the file further

      types     = StoredText.create(:text_data =>  types_doc.serialize(     :encoding => 'UTF-8') {|config| config.format.as_xml})
      assets    = StoredText.create(:text_data =>  assets_doc.serialize(    :encoding => 'UTF-8') {|config| config.format.as_xml})
      locations = StoredText.create(:text_data =>  locations_doc.serialize( :encoding => 'UTF-8') {|config| config.format.as_xml})

      prune_and_insert_uploads(params[:company_id], assets, locations, types)
    else
      # hand off this task to backburner
      delete_former_records(params[:company_id])
      
      # hand off this task to delayed_job
      insert_locations(locations_doc.serialize, params[:company_id]) # pass the XML document as a serialized string so it plays nice with backburner
    end
    "ok"
  end

  def self.prune_and_insert_uploads(company_id, assets, locations, types)
    self.delete_former_records(company_id)

    # insert new records managing access_ids to maintain relationships 
    # locations_doc = Nokogiri::XML(locations.text_data) { |cfg| cfg.noblanks }
    # assets_doc    = Nokogiri::XML(assets.text_data) { |cfg| cfg.noblanks }
    # types_doc     = Nokogiri::XML(types.text_data) { |cfg| cfg.noblanks }
    locations_doc = locations.text_data
    assets_doc = assets.text_data
    types_doc = types.text_data

    type_ids      = self.insert_types(types_doc, company_id)
    location_ids  = self.insert_locations(locations_doc, company_id)

    # hand off job to backburner
    self.async.insert_assets(assets_doc, company_id, type_ids, location_ids)

    # remove from stored text
    assets.destroy
    types.destroy
    locations.destroy
  end

  handle_static_asynchronously :prune_and_insert_uploads

  private

  def self.delete_former_records(company_id)
    StagingArea.destroy_all(:staging_area_company_id => company_id)
    StagingAreaAssetType.destroy_all(:staging_area_company_id => company_id)    
  end
  handle_static_asynchronously :delete_former_records

  def self.check_existence_of(required_fields, xml, filename)
    required_fields.each do |field|
      raise Exception, "#{field} is a required field in #{filename} file." if xml.css(field).empty?
    end
  end

  def self.insert_assets(assets, company_id, type_ids, location_ids)
    assets = Nokogiri::XML(assets) { |cfg| cfg.noblanks }
    assets.css('row').each do |node|
      asset = {}
      node.children.each do |child|
        if child.name != "detail"
          asset[child.name.downcase.to_sym] = self.prepare(child.content.to_s) 
        end
      end
      asset[:staging_area_id] = location_ids[ node.css('staging_area_id').text.to_i ]
      asset[:staging_area_asset_type_id] = type_ids[ node.css('staging_area_asset_type_id').text.to_i ]
      s = StagingAreaAsset.create(asset)
      node.css('detail').each do |detail|
        label = detail.child['label'] || detail.child.name
        StagingAreaAssetDetail.create(:name => label, :value => self.prepare(detail.child.content.to_s), :staging_area_asset_id => s.id)
      end
    end
  end
  handle_static_asynchronously :insert_assets

  def self.insert_locations (locations_raw, company_id)
    locations = Nokogiri::XML(locations_raw) {|config| config.noblanks} # reconstruct the nokogiri xml document object from the string passed in
    location_ids = {}
    locations.css('row').each do |node|
      logger.info node.inspect
      location = {:staging_area_company_id => company_id}
      node.children.each do |child|
        if child.name != "detail"
          location[child.name.downcase.to_sym] = self.prepare(child.content.to_s) unless child.name.downcase == "text"
        end
      end
      logger.info location.inspect
      s = StagingArea.create(location)
      location_ids[node.css('access_id').text.to_i] = s.id
      node.css('detail').each do |detail|
        label = detail.child['label'] || detail.child.name
        StagingAreaDetail.create(:name => label, :value => self.prepare(detail.child.content.to_s), :staging_area_id => s.id)
      end
    end
    location_ids
  end

  handle_static_asynchronously :insert_locations

  def self.insert_types (types, company_id)
    types = Nokogiri::XML(types) { |cfg| cfg.noblanks }
    type_ids = {}
    types.css('row').each do |node|
      s = StagingAreaAssetType.create(
      :staging_area_company_id => company_id, :name => node.css('name').text
      )
      type_ids[node.css('access_id').text.to_i] = s.id
    end
    type_ids
  end

  handle_static_asynchronously :insert_types

  def self.prepare(data)
    (data.class == String && data.to_i.to_s == data) ? data.to_i : data
  end

end