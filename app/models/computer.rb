class Computer < ActiveRecord::Base
  before_create :set_encrypt_key, :encrypt_password
  before_update :update_password
  before_save :mac_address_to_upper

  #IP_REGEX = /\A(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\z/
  #HOSTNAME_REGEX = /\A(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])\z/
  HOSTNAME_AND_IP = /(\A(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\z)|(\A(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])\z)/
  MAC_REGEX = /\A([0-9A-F]{2}[:]){5}([0-9A-F]{2})\z/i

  validates :ip_address, presence: true,
                         uniqueness: true,
                         format: {with: HOSTNAME_AND_IP, message: "not a valid domain name or IP address"}
  validates :mac_address, presence: true,
                          uniqueness: true,
                          format: {with: MAC_REGEX, message: "must be in the form : XX:XX:XX:XX:XX:XX"}
  validates :name, presence: true
  validates :username, presence: true
  validates :password, presence: true  
  
  enum power_status: [:off, :on]
  
  #pagination
  self.per_page = 10
  
  def update_power_status
    if system("ping -c 2 #{self.ip_address}")
      self.power_status = "on"
    else
      self.power_status = "off"
    end
    self.save
  end
  
  def mac_address_to_upper
    self.mac_address.upcase!
  end
  
  def netmask
    IPAddr.new("255.255.255.255").mask(self.netmask_cidr)
  end

  def power_on
    require 'ipaddr'
    require 'resolv'
    
    ip = Resolv.getaddress self.ip_address
    ipaddr = IPAddr.new ip    
    mask = netmask
    
    broadcast = ipaddr | (~mask)            
    
    out = `wakeonlan -i #{broadcast.to_s} #{self.mac_address}`
    #update_power_status
  end  
  
  def power_off
    out = `./bin/rshutdown.sh #{self.ip_address} #{self.username} #{decrypt_password}`
    #update_power_status
  end
  
  def self.AllCidr
    cidr = []
    for i in 1..32
      cidr << i
    end
    cidr
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
