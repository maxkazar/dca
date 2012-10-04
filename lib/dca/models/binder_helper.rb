 module DCA
  module Models
    module BinderHelper
      extend ActiveSupport::Concern

      module ClassMethods
        def convert value, type
          case type
            when :integer
              value.to_s.gsub(/[^\d.,]/,'').gsub(/,/,'.').to_i
            when :float
              value.to_s.gsub(/[^\d.,]/,'').gsub(/,/,'.').to_f
            when :string
              value.to_s.strip
            when :symbol
              value.to_s.to_sym
            when :datetime
              DateTime.parse(value).to_time.utc unless value.nil?
            else
              value
          end
        end

        def parse_options object, value, params
          options = params[:options] || {}
          result = value
          if result.nil?
            result = options[:default]  unless options[:default].nil?
          else
            result = value[options[:regex], 1] unless options[:regex].nil?
          end

          parser = "#{params[:field]}_parser"
          result = object.send(parser, result) if object.respond_to? parser

          result
        end

        def find_type object, field, polymorphic = nil
          type_name = field.to_s.singularize.camelize
          type_name = "#{object.send(polymorphic).to_s.camelize}#{type_name}" if polymorphic
          type = type_name.safe_constantize
          type = "#{object.class.to_s.deconstantize}::#{type_name}".constantize if type.nil?

          type
        end
      end
    end
  end
end
