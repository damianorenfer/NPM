class Computer < ActiveRecord::Base
  before_create :set_encrypt_key, :encrypt_password
  before_update :update_password
  before_save :mac_address_to_upper

  IP_REGEX = /\A(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\z/
  MAC_REGEX = /\A([0-9A-F]{2}[:]){5}([0-9A-F]{2})\z/i

  validates :ip_address, presence: true,
                         format: {with: IP_REGEX, message: "must be in the form : xxx.xxx.xxx.xxx"}
  validates :mac_address, presence: true,
                          format: {with: MAC_REGEX, message: "must be in the form : XX:XX:XX:XX:XX:XX"}
  validates :name, presence: true
  validates :password, presence: true
  
  enum power_status: [:off, :on]
  
  def update_power_status
    if system("ping -c 2 #{self.ip_address}")
      self.power_status = "on"
    else
      self.power_status = "off"
    end
  end
  
  def mac_address_to_upper
    self.mac_address.upcase!
  end

  def power_on
    out = `wakeonlan #{self.mac_address}`
  end  
  
  def power_off
    `./bin/rshutdown.sh #{self.ip_address} #{self.username} #{self.decrypt_password}`
  end

  private
  
  def set_encrypt_key
    self.password_encrypt_key = SecureRandom.hex(64)
  end   

  def encrypt_password
    require 'openssl'
    require 'securerandom'
    require 'base64'           

    cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    cipher.encrypt
    cipher.iv = Rails.application.secrets.secret_key_password_encrypt_iv
    cipher.key = self.password_encrypt_key

    self.password = cipher.update(self.password) + cipher.final
    self.password = Base64.encode64(self.password)
  end  
  
  def decrypt_password
    require 'openssl'    
    require 'base64'    
    
    encrypted = Base64.decode64(self.password.encode('ascii-8bit'))          
    
    decipher = OpenSSL::Cipher::AES.new(128, :CBC)
    decipher.decrypt
    decipher.key = self.password_encrypt_key
    decipher.iv= Rails.application.secrets.secret_key_password_encrypt_iv
       
    decipher.update(encrypted) + decipher.final   
  end
  
  def update_password    
    if self.password != self.password_was
        set_encrypt_key
        encrypt_password
    end
  end

end
