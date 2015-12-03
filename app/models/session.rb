# == Schema Information
# Schema version: 20100727173851
#
# Table name: sessions
#
#  id         :integer         primary key
#  user_id    :integer
#  ip_address :string(255)
#  path       :string(255)
#  created_at :timestamp
#  updated_at :timestamp
#

class Session < ActiveRecord::Base
  attr_accessor :username, :password, :match, :passwordlabel
 
  belongs_to :user
 
  before_validation :authenticate_user
 
  validates_presence_of :match, :message => 'for your username and password could not be found',
                                :unless => :session_has_been_associated?
 
  before_save :associate_session_to_user
  
  private
 
  def authenticate_user
    self.match = User.find_by_username_and_password(self.username, self.password) unless session_has_been_associated?
  end
 
  def associate_session_to_user
    self.user_id ||= self.match.id
  end
 
  def session_has_been_associated?
    self.user_id
  end
end
