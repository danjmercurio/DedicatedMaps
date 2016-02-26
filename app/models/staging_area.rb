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

    # Error flag for this entire function.
    error = false
    # Container for the eventual return message.
    message = "";

    begin
      locationsFile = params[:map_locations]
      # Get the contents and construct Nokogiri instance
      locationsNoko = Nokogiri::XML(File.open(locationsFile.path)) do |config|
        config.strict.noblanks
      end

      # Verify contents
      required_fields = ['LocationCode', 'LocationName', 'Latitude', 'Longitude']
      self.check_existence_of(required_fields, locationsNoko, "Map Locations file: #{locationsFile.original_filename}")

      # Name of parent XML element of all map locations (if the XML is valid!)
      # This is a constant
      $LOCATIONS_XML_IDENTIFIER = 'qry_Map_Locations'
      if locationsNoko.search($LOCATIONS_XML_IDENTIFIER).count > 0
        error = true
        message += "XML Parser found no locations. Check file #{locationsFile.original_filename} for formatting errors."
        raise Nokogiri::XML::SyntaxError
      end

      # Apply an XML transformation
      xslt = Nokogiri::XSLT(File.read('ddscripts/staging_areas/Map_Locations.xsl'))
      locationsNoko = xslt.transform(locationsNoko)

      locationsText = StoredText.create(:text_data => locationsNoko.serialize { |config| config.format.as_xml })
    rescue Nokogiri::XML::SyntaxError => e
      error = true
      message += e.to_s + " in " + locationsFile.original_filename
    rescue Exception => e
      error = true
      message += e.to_s + " in " + locationsFile.original_filename
    end

    if params.has_key? :map_asset_types
      begin
        assetTypesFile = params[:map_asset_types]

        assetTypesNoko = Nokogiri::XML(File.open(assetTypesFile.path)) do |config|
          config.strict.noblanks
        end

        self.check_existence_of(["AssetTypeCode", "AssetTypeName"], assetTypesNoko, "Map Asset Types file: #{assetTypesFile.original_filename}")

        $ASSET_TYPES_XML_IDENTIFIER = 'qry_Map_Asset_Types'

        if assetTypesNoko.search($ASSET_TYPES_XML_IDENTIFIER).count <= 0
          raise Nokogiri::XML::SyntaxError
        end

        xslt = Nokogiri::XSLT(File.read("ddscripts/staging_areas/Map_Asset_Types.xsl"))
        assetTypesNoko = xslt.transform(assetTypesNoko)

        assetTypesText = StoredText.create(:text_data => assetTypesNoko.serialize { |config| config.format.as_xml })
      end
    end
    # Do the same for map asset and asset type files if we have them
    # Note: Nokogiri returns a parse error for XML with non-unicode characters when in strict mode. Strict mode temporarily turned off.
    if params.has_key? :map_assets
      assetsFile = params[:map_assets]

      assetsNoko = Nokogiri::XML(File.open(assetsFile.path)) do |config|
        config.strict.noblanks
      end

      $ASSETS_XML_IDENTIFIER = 'qry_Map_Assets'

      raise "XML Parser received no assets. Check file #{assetsFile.original_filename} for formatting errors." unless assetsNoko.search($ASSETS_XML_IDENTIFIER).count > 0

      self.check_existence_of(["Ident", "LocationCode", "AssetTypeCode", "MapAsset"], assetsNoko, "Map Assets file: #{assetsFile.original_filename}")
      xslt = Nokogiri::XSLT(File.read("ddscripts/staging_areas/Map_Assets.xsl"))
      assetsNoko = xslt.transform(assetsNoko)

      assetsText = StoredText.create(:text_data => assetsNoko.serialize { |config| config.format.as_xml })
    end



    # We have our validated XML, so start inserting
    delete_former_records(params[:company_id])
      location_ids = insert_locations(locationsNoko, params[:company_id])
    # We need these location IDs to continue. If we don't have them, something went wrong
    raise 'Attempted to insert locations but routine to do so returned no location IDs' unless location_ids.count > 0


    # if assetTypesNoko
    type_ids = insert_types(assetTypesNoko, params[:company_id])
    # end

    # if assetsNoko
    insert_assets(assetsNoko, type_ids, location_ids)
    # end

    # rescue Nokogiri::XML::SyntaxError => e
    #   return "XML Syntax Error: #{e.message}"
    # rescue Exception => e
    #   return e.message
    # end

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
    self.insert_assets(assets_doc, type_ids, location_ids)

    # remove from stored text
    assets.destroy
    types.destroy
    locations.destroy
  end

  private

  def self.delete_former_records(company_id)
    StagingArea.destroy_all(:staging_area_company_id => company_id)
    StagingAreaAssetType.destroy_all(:staging_area_company_id => company_id)    
  end

  def self.check_existence_of(required_fields, xml, filename)
    required_fields.each do |field|
      raise "#{field} is a required field in #{filename} file." if xml.search(field).empty?
    end
  end

  def self.stripNewLines(string)
    return string.gsub(/\s+/, "")
  end

  def self.insert_assets(assets, type_ids, location_ids)
    raise 'Routine to insert Staging Area Assets called, but XML object has no assets.' unless assets.css('row').count > 0
    assets.css('row').each do |node|
      logger.info node.inspect
      asset = {}
      node.children.each do |child|
        asset[child.name.downcase.to_sym] = self.prepare(child.content.to_s) unless child.name == 'detail'
      end
      asset[:staging_area_id] = location_ids[node.css('staging_area_id').text.to_i]
      asset[:staging_area_asset_type_id] = type_ids[node.css('staging_area_asset_type_id').text.to_i]
      s = StagingAreaAsset.create(asset)
      node.css('detail').each do |detail|
        label = detail.child['label'] || detail.child.name
        StagingAreaAssetDetail.create(:name => label, :value => self.prepare(detail.child.content.to_s), :staging_area_asset_id => s.id)
      end
    end
  end

  def self.insert_locations (locations, company_id)
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

  def self.insert_types (types, company_id)
    type_ids = {}
    types.css('row').each do |node|
      s = StagingAreaAssetType.create(
      :staging_area_company_id => company_id, :name => node.css('name').text
      )
      type_ids[node.css('access_id').text.to_i] = s.id
    end
    type_ids
  end

  def self.prepare(data)
    (data.class == String && data.to_i.to_s == data) ? data.to_i : data
  end
end