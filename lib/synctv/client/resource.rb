class Synctv::Client::Resource < ActiveResource::Base
  include ActiveModel::Dirty
  extend Synctv::ActiveResource::Scopes
  
  with_api_auth
  
  self.prefix           = "/api/v2/"
  self.format           = :json
  
  # localhost
  self.site             = "http://localhost:5000"
  self.client_key       = "upDEo1zNiqxGsrGHrzzBAC5ZFveYmHHped1RFK6Vtt8r"
  self.device_uid       = "my_device_uid"
  self.account_email    = "manager@synctv.com"
  self.account_password = "sdf123gGG!"

  # tf1-staging
  # self.site             = "https://tf1-staging.synctv.com/api/v2/"
  # self.client_key       = "BzeNrv15xQVRJBDVfFabjreqq5vyMC8qkWuiQ22HHcEr"
  # self.device_uid       = "my_device_uid"
  # self.account_email    = "cpw@synctv.com"
  # self.account_password = "5ynCPW!"

  # v2-dev
  # self.site             = "https://v2-dev.synctv.com/api/v2/"
  # self.client_key       = "BzeNrv15xQVRJBDVfFabjreqq5vyMC8qkWuiQ22HHcEr"
  # self.device_uid       = "my_device_uid"
  # self.account_email    = "manager@synctv.com"
  # self.account_password = "sdf123gGG!"

  # tf1-dev
  # self.site             = "https://tf1-dev.synctv.com/api/v2/"
  # self.client_key       = "908234CVXBNfhjksdiuewr89234KJHyfduisdbxvcnk8"  # "upDEo1zNiqxGsrGHrzzBAC5ZFveYmHHped1RFK6Vtt8r"
  # self.device_uid       = "my_device_uid"
  # self.account_email    = "admin@synctv.com"
  # self.account_password = "zklAu89q"
  # self.account_email    = "manager@synctv.com"
  # self.account_password = "sdf123gGG!"
  # self.account_email    = "cpw@synctv.com"
  # self.account_password = "5ynCPW!"

  self.ssl_options = {
    # :cert         => OpenSSL::X509::Certificate.new(File.open(pem_file)),
    # :key          => OpenSSL::PKey::RSA.new(File.open(pem_file)),
    # :ca_path      => "/path/to/OpenSSL/formatted/CA_Certs",
    :verify_mode  => OpenSSL::SSL::VERIFY_NONE # OpenSSL::SSL::VERIFY_PEER
  }

  # Attempts to +save+ the record and clears changed attributes if successful.
  def save(*) #:nodoc:
    if status = super
      @previously_changed = changes
      @changed_attributes.clear
    end
    status
  end

  # Attempts to <tt>save!</tt> the record and clears changed attributes if successful.
  def save!(*) #:nodoc:
    super.tap do
      @previously_changed = changes
      @changed_attributes.clear
    end
  end

  # <tt>reload</tt> the record and clears changed attributes.
  def reload(*) #:nodoc:
    super.tap do
      @previously_changed.clear
      @changed_attributes.clear
    end
  end
  
  def encode_changes(options={})
    hash = changes.keys.inject({}) {|h, k| h[k] = attributes[k]; h}
    hash = {self.class.element_name => hash}
    hash.send("to_#{self.class.format.extension}", options)
  end
  
  protected
  
  # To satisfy ActiveModel::AttributeMethods __self__ call
  def attribute(method_name)
    attributes[method_name]
  end
  
  # Update the resource on the remote service, but only those attributes that have changed.
  def update
    connection.put(element_path(prefix_options), encode_changes, self.class.headers).tap do |response|
      load_attributes_from_response(response)
    end
  end
  
  private
  
  # Overload method_missing from ActiveResource::Base to include
  # ActiveModel::Dirty attribute changes
  def method_missing(method_symbol, *arguments) #:nodoc:
    method_name = method_symbol.to_s

    if method_name =~ /(=|\?)$/
      case $1
      when "="
        send("#{$`}_will_change!") unless attributes[$`] == arguments.first
        attributes[$`] = arguments.first
      when "?"
        attributes[$`]
      end
    else
      return attributes[method_name] if attributes.include?(method_name)
      # not set right now but we know about it
      return nil if known_attributes.include?(method_name)
      super
    end
  end
  
end
