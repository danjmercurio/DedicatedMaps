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

    # begin
    locationsFile = params[:map_locations]

    # Get the contents and construct Nokogiri instance
    locationsNoko = Nokogiri::XML(File.open(locationsFile.path)) do |config|
      config.strict.noblanks
      end

    # Name of parent XML element of all map locations (if the XML is valid!)
    # This is a constant
    $LOCATIONS_XML_IDENTIFIER = 'qry_Map_Locations'

    raise Exception("XML Parser received no locations. Check file #{locationsFile.original_filename} for formatting errors.") unless locationsNoko.search($LOCATIONS_XML_IDENTIFIER).count > 0

    # Verify contents
      required_fields = ['LocationCode', 'LocationName', 'Latitude', 'Longitude']
    self.check_existence_of(required_fields, locationsNoko, "Map Locations file: #{locationsFile.original_filename}")

    # Apply an XML transformation
      xslt = Nokogiri::XSLT(File.read('ddscripts/staging_areas/Map_Locations.xsl'))
    locationsNoko = xslt.transform(locationsNoko)

    locationsText = StoredText.create(:text_data => locationsNoko.serialize { |config| config.format.as_xml })


    # Do the same for map asset and asset type files if we have them
    # Note: Nokogiri returns a parse error for XML with non-unicode characters when in strict mode. Strict mode temporarily turned off.
    # mapAssets = nil
    # if params.has_key? :map_assets
    #   mapAssetsOriginalFileName = params[:map_assets].original_filename
    #   mapAssetsFile = File.read(params[:map_assets].path)
    #
    #   # Remove all \n characters from XML string
    #   mapAssetsFile = self.stripNewLines(mapAssetsFile)
    #
    #   raise Exception("Map assets file #{mapAssetsOriginalFileName} is empty or was not completely received.") unless mapAssetsFile.length > 4 # Compare against 4 rather than zero to disqualify one-word or one-letter files
    #   mapAssets = Nokogiri::XML(mapAssetsFile) do |config|
    #     config.strict
    #   end
    #
    #   self.check_existence_of(["Ident", "LocationCode", "AssetTypeCode", "MapAsset"], mapAssets, "Map Assets file: #{mapAssetsOriginalFileName}")
    #   xslt = Nokogiri::XSLT(File.read("ddscripts/staging_areas/Map_Assets.xsl"))
    #   mapAssets = xslt.transform(mapAssets)
    #
    #   mapAssetsText = StoredText.create(:text_data => mapAssets.serialize {|config| config.format.as_xml})
    # end
    #
    # mapAssetTypes = nil
    # if params.has_key? :map_asset_types
    #   mapAssetTypesOriginalFileName = params[:map_asset_types].original_filename
    #   mapAssetTypesFile = File.read(params[:map_asset_types].path)
    #
    #   # Remove all \n characters from XML string
    #   mapAssetTypesFile = self.stripNewLines(mapAssetTypesFile)
    #
    #   raise Exception("Map asset types file #{mapAssetTypesOriginalFileName} is empty or was not completely received.") unless mapAssetTypesFile.length > 4
    #   mapAssetTypes = Nokogiri::XML(mapAssetTypesFile) do |config|
    #     config.strict
    #   end
    #
    #   self.check_existence_of(["AssetTypeCode", "AssetTypeName"], mapAssetTypes, "Map Asset Types file: #{mapAssetTypesOriginalFileName}")
    #   xslt = Nokogiri::XSLT(File.read("ddscripts/staging_areas/Map_Asset_Types.xsl"))
    #   mapAssetTypes = xslt.transform(mapAssetTypes)
    #
    #   mapAssetTypesText = StoredText.create(:text_data => mapAssetTypes.serialize {|config| config.format.as_xml})
    # end

    # We have our validated XML, so start inserting
    delete_former_records(params[:company_id])
    if locationsNoko
      location_ids = insert_locations(locationsNoko, params[:company_id])
      # We need these location IDs to continue. If we don't have them, something went wrong
      raise Exception('Attempted to insert locations but routine to do so returned no location IDs') unless location_ids.count > 0
      end

    # if mapAssetTypes
    #   type_ids = insert_types(mapAssetTypesFile, params[:company_id])
    # end
    #
    # if mapAssets
    #   insert_assets(mapAssetsFile, type_ids, location_ids)
    # end

    # rescue Nokogiri::XML::SyntaxError => e
    #   return "XML Syntax Error: #{e.message}"
    # rescue Exception => e
    #   return e.message
    # end
    "OK"
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
      raise Exception, "#{field} is a required field in #{filename} file." if xml.search(field).empty?
    end
  end

  def self.stripNewLines(string)
    return string.gsub(/\s+/, "")
  end

  def self.insert_assets(assets, type_ids, location_ids)
    assets = Nokogiri::XML(assets) { |cfg| cfg.noblanks }
    assets.css('row').each do |node|
      asset = {}
      node.children.each do |child|
        if child.name != "detail"
          asset[child.name.downcase.to_sym] = self.prepare(child.content.to_s) 
        end
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

  def self.prepare(data)
    (data.class == String && data.to_i.to_s == data) ? data.to_i : data
  end
end