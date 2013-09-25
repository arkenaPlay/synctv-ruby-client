# Derived from https://github.com/mgomes/api_auth
# Net:HTTP cheat sheet: https://github.com/augustl/net-http-cheat-sheet
# Excon: https://github.com/geemus/excon
# Net HTTP cheat sheet: http://www.rubyinside.com/nethttp-cheat-sheet-2940.html
module Synctv
  module Client
    module ApiAuth

      class << self
        
        # Appends access_id and access_secret to a given request.
        #
        # Usage:
        #
        #     site     = "http://service.synctv.com/"
        #     uri      = URI.parse(site)
        #     http     = Net::HTTP.new(uri.host, uri.port)
        #     request  = Net::HTTP::Get.new("/api/v2/media.json",
        #       'content-type' => 'text/plain')
        #     access_id, access_secret = Synctv::Client::ApiAuth.authorize! 
        #       site, "client_key", "device_uid", "account@email.com", "account_password"
        #     Synctv::Client::ApiAuth.append_signature!(request, access_id, access_secret)
        #     response = http.request(request)
        #
        def authorize!(site, client_key, device_uid = nil, account_email = nil, account_password = nil)
          access_id, access_secret = client_authorize!(site, client_key, device_uid)
          if account_email && account_password
            user_authorize!(site, access_id, access_secret, account_email, account_password)
          end
          return access_id, access_secret
        end
        
        def client_authorize!(site, client_key, device_uid = nil)
          http = Net::HTTP.new(site.host, site.port)
          if site.scheme == "https"
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          auth_request = Net::HTTP::Post.new("/api/v2/authorization/user/client_authorize.json?client_key=#{client_key}&device_uid=#{device_uid}")
          response = http.request(auth_request)
          
          if response.is_a?(Net::HTTPSuccess)
            body = JSON.parse(response.body)
            return body["response"]["access_id"], body["response"]["access_secret"]
          else 
            raise "Could not authorize client."
          end
        end
        
        def user_authorize!(site, access_id, access_secret, account_email, account_password)
          http = Net::HTTP.new(site.host, site.port)
          if site.scheme == "https"
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          auth_request = Net::HTTP::Post.new("/api/v2/authorization/user/user_authorize.json?email=#{account_email}&password=#{account_password}&access_id=#{access_id}")
          path         = append_signature!(auth_request, access_id, access_secret)
          auth_request = Net::HTTP::Post.new(path)
          
          response = http.request(auth_request)
          
          if response.is_a?(Net::HTTPSuccess)
            true
          else 
            raise "Could not authorize user."
          end
        end
        
        def generate_signature!(request, access_id, access_secret)
          access_id     ||= request["access_id"]
          access_secret ||= request["access_secret"]
          filter_keys   = [:signature, :id]

          # Replace rack query parser with standalone parser
          # params = CGI::parse(URI.parse(request.path).query || "")
          params = Rack::Utils.parse_nested_query(URI.parse(request.path).query || "").symbolize_keys
          params.merge!(ActiveSupport::JSON.decode(request.body)) unless request.body.blank?
          params.merge!(:access_id => access_id)

          query = params.symbolize_keys.reject {|k, _| filter_keys.include?(k)}.to_query
          query = query.split('&').sort.reject(&:blank?).join('&')

          request["signature"] = Digest::MD5.hexdigest(query + access_secret)
        end
        
        def append_signature!(request, access_id = nil, access_secret = nil)
          access_id     ||= request["access_id"]
          access_secret ||= request["access_secret"]
          generate_signature!(request, access_id, access_secret)
          uri = URI.parse(request.path)
          # Replace rack query parser with standalone parser
          # params = CGI::parse(uri.query || "").symbolize_keys
          params = Rack::Utils.parse_nested_query(uri.query || "").symbolize_keys
          params.merge!(ActiveSupport::JSON.decode(request.body)) unless request.body.blank?
          params.merge!({:access_id => access_id, :signature => request["signature"]})
          request.set_form_data(params)
          uri.query = params.to_query.split('&').reject(&:blank?).join('&') # params.to_query
          request["path"] = uri.to_s
        end
        
      end

      # Integration with Rails
      #
      class Rails # :nodoc:

        module ControllerMethods # :nodoc:

          module InstanceMethods # :nodoc:

            def get_api_access_id_from_request
              ApiAuth.access_id(request)
            end

            def api_authenticated?(secret_key)
              ApiAuth.authentic?(request, secret_key)
            end

          end

          unless defined?(ActionController)
            begin
              require 'rubygems'
              gem 'actionpack'
              gem 'activesupport'
              require 'action_controller'
              require 'active_support'
            rescue LoadError
              nil
            end
          end

          if defined?(ActionController::Base)        
            ActionController::Base.send(:include, ControllerMethods::InstanceMethods)
          end

        end # ControllerMethods

        module ActiveResourceExtension  # :nodoc:

          module ActiveResourceApiAuth # :nodoc:

            def self.included(base)
              base.extend(ClassMethods)
            end

            module ClassMethods

              # Gets the \client_key for SyncTV's signature authentication.
              def client_key
                # Not using superclass_delegating_reader. See +site+ for explanation
                if defined?(@client_key)
                  @client_key
                elsif superclass != Object && superclass.client_key
                  superclass.client_key.dup.freeze
                end
              end

              # Sets the \client_key for SyncTV's signature authentication.
              def client_key=(client_key)
                @connection = nil
                @client_key = client_key
              end

              # Gets the \device_uid for SyncTV's signature authentication.
              def device_uid
                # Not using superclass_delegating_reader. See +site+ for explanation
                if defined?(@device_uid)
                  @device_uid
                elsif superclass != Object && superclass.device_uid
                  superclass.device_uid.dup.freeze
                end
              end

              # Sets the \device_uid for SyncTV's signature authentication.
              def device_uid=(device_uid)
                @connection = nil
                @device_uid = device_uid
              end

              # Gets the \account_email for SyncTV's signature authentication.
              def account_email
                # Not using superclass_delegating_reader. See +site+ for explanation
                if defined?(@account_email)
                  @account_email
                elsif superclass != Object && superclass.account_email
                  superclass.account_email.dup.freeze
                end
              end

              # Sets the \account_email for SyncTV's signature authentication.
              def account_email=(account_email)
                @connection = nil
                @account_email = account_email
              end

              # Gets the \account_password for SyncTV's signature authentication.
              def account_password
                # Not using superclass_delegating_reader. See +site+ for explanation
                if defined?(@account_password)
                  @account_password
                elsif superclass != Object && superclass.account_password
                  superclass.account_password.dup.freeze
                end
              end

              # Sets the \account_password for SyncTV's signature authentication.
              def account_password=(account_password)
                @connection = nil
                @account_password = account_password
              end

              def with_api_auth(client_key = nil, device_uid = nil, account_email = nil, account_password = nil)
                self.client_key       = client_key if client_key
                self.device_uid       = device_uid if device_uid
                self.account_email    = account_email if account_email
                self.account_password = account_password if account_password

                class << self
                  alias_method_chain :connection, :auth
                end
              end

              def connection_with_auth(refresh = false) 
                c = connection_without_auth(refresh)
                c.client_key       = self.client_key
                c.device_uid       = self.device_uid
                c.account_email    = self.account_email
                c.account_password = self.account_password
                c
              end

            end # class methods

            module InstanceMethods
            end

          end # BaseApiAuth

          module Connection

            def self.included(base)
              base.send :alias_method_chain, :request, :auth
              base.class_eval do
                attr_accessor :client_key, :device_uid, :account_email, :account_password, :access_id, :access_secret
              end
            end

            def request_with_auth(method, path, *arguments)
              h        = arguments.last
              rqs      = "Net::HTTP::#{method.to_s.capitalize}".constantize.new(path, h)
              rqs.body = arguments[0] if arguments.length > 1
              if access_id && access_secret
                path   = ApiAuth.append_signature!(rqs, access_id, access_secret)
              elsif client_key
                self.access_id, self.access_secret = ApiAuth.authorize!(
                  site, client_key, device_uid, account_email, account_password)
                path = ApiAuth.append_signature!(rqs, access_id, access_secret)
              end
              puts " [#{method.to_s.upcase}] #{site.scheme}://#{site.host}#{site.port ? ":#{site.port}" : ""}#{path}"
              # Temporary hack to set Content-Type: "application/json" to empty, so that SyncTV's 
              # signature calulation algorithm doesn't pick up the additionally created form 
              # parameter that is created for a resource.
              arguments.map! {|a| a.is_a?(Hash) && a["Content-Type"] ? {"Content-Type"=>""} : a} if [:post, :put].include?(method)
              request_without_auth(method, path, *arguments)
            end
            
          end # Connection

          unless defined?(ActiveResource)
            begin
              require 'rubygems'
              gem 'activeresource'
              require 'active_resource'
            rescue LoadError
              nil
            end
          end

          if defined?(ActiveResource)
            ActiveResource::Base.send(:include, ActiveResourceApiAuth)        
            ActiveResource::Connection.send(:include, Connection)
          end 

        end # ActiveResourceExtension

      end # Rails

    end # ApiAuth
  end # Client
end # Synctv