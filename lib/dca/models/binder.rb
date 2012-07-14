module DCA
  module Models
    module Binder
      extend ActiveSupport::Concern

      COMPLEX_TYPE = [:integer, :float, :string, :symbol, :datetime]

      module ClassMethods
        def binder name = :nokogiri
          @binder ||= "DCA::Models::#{name.to_s.camelize}Binder".constantize
        end

        def has_one field, *args
          options  = args.extract_options!
          type = args.first
          add_association field, :one, type, options
        end

        def has_many field, *args
          options  = args.extract_options!
          type = args.first
          add_association field, :many, type, options
        end

        def associations complex = false
          @associations ||= {}

          return associations.select { |field, options| !COMPLEX_TYPE.include?(options[:type])  } if complex

          @associations
        end

        def inherited(child)
          associations.each { |field, options| child.associations[field] = options}
        end

        private

        def add_association field, association, type, options = {}
          associations[field] = { :association => association, :field => field, :type => type, :options => options }
          instance_eval do
            attr_accessor field.to_sym unless instance_variable_defined? "@#{field}"
          end
        end
      end

      def bind content
        self.class.associations.each do |field, options|
          update field, self.class.binder.parse(self, content, options), options[:options][:append]
        end
        self
      end

      private

      def update field, value, append = false
        if append
          new_value = self.instance_variable_get("@#{field.to_s}")
          new_value  = new_value ? new_value + value : value
          self.instance_variable_set "@#{field.to_s}", new_value
        else
          self.instance_variable_set "@#{field.to_s}", value
        end
      end
    end
  end
end

