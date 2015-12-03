require 'digest/sha2'

class User < ActiveRecord::Base
    attr_reader :password
    
    ENCRYPT = Digest::SHA256

    has_many :sessions, :dependent => :destroy
    has_many :logins, :dependent => :destroy
    has_many :licenses
    has_many :tags
    has_many :assets, :through => :tags
    
    has_and_belongs_to_many :layers, :join_table => :layers_users_privileges
    
    has_one :map, :dependent => :destroy
    
    belongs_to :client
    belongs_to :privilege
    
    validates_presence_of :username, :within => 3..40
    validates_presence_of :first_name, :last_name, :username, :email
    validates_presence_of :password, :salt, :on => :create
  
    validates_uniqueness_of :username, :message => "or subdomain is already in use by another person"
    validates_uniqueness_of :email, :message => 'is already in used by another user'
    
    validates_format_of :username, :with => /^([a-z0-9_]{2,26})$/i,
                        :message => "must be 4 to 26 letters, numbers, or underscores and have no spaces"
  
    validates_format_of :password, :with => /^([\x20-\x7E]){4,26}$/,
                        :message => "must be 4 to 26 characters",
                        :unless => :password_is_not_being_updated?
  
    validates_format_of :email, :with => /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
                        :message => "must be a valid email address"
    
    validates_confirmation_of :password, :on => :create

    validates_exclusion_of :username, :in => %w( support blog www billing help api ), :message => "The subdomain <strong>{{value}}</strong> is reserved and unavailable."
      
    before_save :scrub_username
    after_save :flush_passwords

    def super?
      priv = Privilege.find(self.privilege_id)
      priv.name == 'super'
    end

    def admin?
      priv = Privilege.find(self.privilege_id)
      priv.name == 'admin'
    end
    
    def is?(user)
      self.id == user.id
    end
      
    def has_license?
      licenses = License.find(:all, :conditions => "client_id = #{self.client.id}")
      licenses.any? {|license| !license.deactivated && (license.expires > Time.now)}
    end
    
    def account_active?
      self.client.active && self.active
    end
    
    def admin_for?(user)
      #  super users can admin all
      # admins can admin all with the same client_id
      # users can admin themselves only.
      self.super? || ((user.client_id == self.client_id) & self.admin?) || self.is?(user)
    end

    def self.find_by_username_and_password(username, password)
      user = self.find_by_username(username)
      if user and user.hashed_password == ENCRYPT.hexdigest(password + user.salt)
        return user
      end
    end

    def temp_password
      #generate temp password for new users and resets, Only use 0-9 a-z A-Z
      return Array.new(9){[48+rand(10), 65+rand(26), 97+rand(26)][rand(3)].chr}.join     
    end
    
    def password=(password)
      @password = password
      unless password_is_not_being_updated?
        self.salt = [Array.new(9){rand(256).chr}.join].pack('m').chomp
        self.hashed_password = ENCRYPT.hexdigest(password + self.salt)
      end
    end
    
    def remove_all_layers
      connection.delete("DELETE FROM layers_users_privileges WHERE user_id = #{id}")
    end
  
  private
  
    def scrub_username
      self.username.downcase!
    end

    def flush_passwords
      @password = @password_confirmation = nil
    end

    def password_is_not_being_updated?
      self.id and self.password.blank?
    end

end

# == Schema Information
#
# Table name: users
#
#  id              :integer         primary key
#  client_id       :integer
#  privilege_id    :integer
#  username        :string(255)
#  hashed_password :string(255)
#  salt            :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  active          :boolean         default(TRUE)
#  eula            :boolean         default(FALSE)
#  last_login      :timestamp
#  created_at      :timestamp
#  updated_at      :timestamp
#  time_zone       :string(255)
#

