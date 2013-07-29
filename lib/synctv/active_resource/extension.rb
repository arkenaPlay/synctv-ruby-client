module Synctv
  module ActiveResource # :nodoc:
    module Extension # :nodoc:
      module Formats # :nodoc:
        def self.included(base)
          base.extend ClassMethods
          base.class_eval do
            class << self
              alias_method_chain :remove_root, :response
            end
          end
        end
      
        module ClassMethods
        
          def remove_root_with_response(data)
            if data.is_a?(Hash) && data.has_key?("response")
              data = data["response"]
              data.values.first
            else
              data
            end
          end
        
        end
      end # Formats
      
      module ConnectionError
        def self.included(base)
          # base.send(:include, InstanceMethods)
          base.class_eval do
            alias_method_chain :to_s, :envelope
          end
        end

        def to_s_with_envelope
          message = to_s_without_envelope
          if data = ActiveSupport::JSON.decode(response.body)
            if data.is_a?(Hash) && (data = data["response"])
              message << "  API code = #{data["code"]}." if data["code"]
              message << "  API messages = #{[data["messages"]].flatten.join(", ")}" if data["messages"]
            end
          end
        end
        
      end
    
      if defined?(::ActiveResource)
        ::ActiveResource::Formats.send(:include, Formats)
        ::ActiveResource::ConnectionError.send(:include, ConnectionError)
      end 
    end # Extension
  end # ActiveResource
end # Synctv