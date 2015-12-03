# == Schema Information
# Schema version: 20100727173851
#
# Table name: clients
#
#  id            :integer         primary key
#  company_name  :string(255)
#  address1      :string(255)
#  address2      :string(255)
#  city          :string(255)
#  zip           :string(255)
#  company_url   :string(255)
#  contact_name  :string(255)
#  contact_phone :string(255)
#  contact_email :string(255)
#  contact_notes :text
#  active        :boolean         default(TRUE)
#  created_at    :timestamp
#  updated_at    :timestamp
#  state         :string(255)
#

class Client < ActiveRecord::Base
  
  has_many :users,          :dependent => :destroy
  has_many :users,          :through => :licenses
  has_many :licenses, :order => "created_at", :dependent => :destroy
  has_many :assets,         :dependent => :destroy
  has_many :shared_assets,  :dependent => :destroy
  # has_many :assets,         :through => :shared_assets
  has_many :devices,        :dependent => :destroy
  has_many :past_locations, :dependent => :destroy
  has_many :fishermen
  has_many :stored_files
    
  has_and_belongs_to_many :layers, :join_table => :clients_layers_privileges
  has_and_belongs_to_many :clients, :join_table => :client_share_privileges, :association_foreign_key => 'recipient_id', :foreign_key => 'sharer_id'

  validates_presence_of :company_name
   
  validates_format_of :contact_email, :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
                      :message => "must be a valid email address"
  
  def remove_all_layers
    connection.delete("DELETE FROM clients_layers_privileges WHERE client_id = #{id}")
  end

  def remove_all_clients
    connection.delete("DELETE FROM client_share_privileges WHERE sharer_id = #{id}")
  end

end
