require 'active_support/core_ext/module/delegation'

module Synctv
  module ActiveResource
    module Scopes
      def scoped
        ActiveResource::Scope.new(self)
      end

      delegate :where, :to => :scoped

      def scopes
        @scopes ||= {}
      end

      def scope(name, *args, &block)
        scopes[name = name.to_sym] = (args.first || block || lambda { |*args| where name => args })
        self.class.delegate name, :to => :scoped
      end
    end

    class Scope
      include Enumerable

      attr_reader :resource_class

      def initialize(resource_class)
        @resource_class = resource_class
      end

      def params
        @params ||= {}
      end

      def to_a
        resource_class.find :all, :params => params
      end

      delegate :each, :to => :to_a
      delegate :inspect, :to => :to_a
      delegate :all, :to => :to_a
      
      def first
        to_a.first
      end

      def last
        to_a.last
      end

      def where(params = {})
        dup.tap {|scope| scope.params.update params}
      end

      delegate :scopes, :to => :resource_class

      def method_missing(name, *args)
        return super unless scopes.key? name
        scope = scopes[name]
        scope = scope.call(*args) if scope.is_a? Proc

        where scope.params
      end
    end
  end
end