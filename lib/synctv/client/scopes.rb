module Synctv
  module Client
    module Scopes

      def self.included(base)
        base.class_eval do
          scope :order, lambda {|params| where(:sort_order => [params].flatten)}
          scope :reverse_order, lambda {where(:sort_descending => true)}
          scope :limit, lambda {|param| where(:limit => param)}
          scope :offset, lambda {|param| where(:offset => param)}
          scope :fields, lambda {|params| where(:fields => [params].flatten)}
          scope :add_fields, lambda {|params| where(:add_fields => [params].flatten)}
          scope :remove_fields, lambda {|params| where(:remove_fields => [params].flatten)}

          class << self
            def count; get(:count); end
          end
        end
      end

    end
  end
end