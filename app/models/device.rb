# == Schema Information
# Schema version: 20100505140900
#
# Table name: devices
#
#  id             :integer         not null, primary key
#  created_at     :datetime
#  updated_at     :datetime
#  client_id      :integer
#  device_type_id :integer
#  request_key    :string(255)
#  serial_number  :string(255)
#  common_name    :string(255)
#  is_active      :boolean         default(TRUE)
#

class Device < ActiveRecord::Base
  belongs_to :client
  belongs_to :device_type

  has_one :current_location, :dependent => :destroy  

  has_many :assets, :through => :tethers
  has_many :tethers, :dependent => :destroy

  # validates_uniqueness_of :serial_number, :scope => :device_type_id, :unless => :is_unclaimed?, :message => 'is already in use.'

  def is_unclaimed?
    # A device with no client (like AIS ship).
    self.client_id.nil?
  end

  def update_location
    details = case device_type.name
      when 'spot'  then get_spot_location
      when 'phone' then get_instamapper_location
    end
    unless details.nil?
      current_location = CurrentLocation.find_or_create_by_device_id(id)
      current_location.update_attributes(details)
      assets.each {|a|
        a.update_attribute(:current_location_id, current_location.to_param)
      }
    end
  end

  private
  require 'net/http'
  require 'nokogiri'

  def get_instamapper_location
    # note: for now, we just get the latest position since we're not storing history.
    # see http://www.instamapper.com/fe?page=api for more info on the Instamapper API
    # raise "www.instamapper.com/api?action=getPositions&key=#{request_key}&format=json"
    begin
      json = Net::HTTP.get('www.instamapper.com', "api?action=getPositions&key=#{request_key}&format=json")
    rescue Exception
      Rails.logger.error 'Device.get_instamapper_location ' + $!.inspect, $@
      return
    end
    Rails.logger.info "Instamapper get key=#{request_key}"
    return if json.nil?
    begin
      data = JSON.parse(json)['positions'][0]
      details = {
        :lat => data['latitude'],
        :lon => data['longitude'],
        :timestamp => Time.zone.at(data['timestamp'])
      }
    rescue JSON::ParserError
      Rails.logger.error 'Device.get_instamapper_location: could not parse json:'
    end
    details
  end

  def get_spot_location
    begin
      xml = Net::HTTP.get('share.findmespot.com', "/messageService/guestlinkservlet?glId=#{request_key}&completeXml=true")
    rescue Exception
      Rails.logger.error 'Device.get_spot_location ' + $!.inspect, $@
      return
    end
    Rails.logger.info "Spot get glId=#{request_key}"
    doc = Nokogiri::XML(xml) { |config| config.strict.noblanks }
    return if doc.nil?
    node = doc.css('message')
    return if node.nil? || node.empty?
    node = node.first
    {:lat =>  node.css('latitude').text, :lon => node.css('longitude').text, :timestamp => DateTime.parse(node.css('timestamp').text)}
  end

end