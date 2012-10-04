module DCA
  module Models
    class NokogiriBinder
      include BinderHelper

      def self.parse object, content, params
        if params[:association] == :one
          parse_one object, content, params
        elsif params[:association] == :many
          parse_many object, content, params
        end
      end

      def self.parse_one object, content, params
        result = nil

        options = params[:options] || {}
        selector = options[:selector]
        element = selector.nil? ? content : content.at_css(selector)
        unless element.nil?
          result = options[:attribute].nil? ? element.content : element[options[:attribute]]
        end
        result = self.parse_options object, result, params

        convert result, params[:type]
      end

      def self.parse_many object, content, params
        result = nil

        options = params[:options] || {}
        selector = options[:selector]
        type = params[:type]
        type = find_type object, params[:field], options[:polymorphic] if type.nil? || options[:polymorphic]

        unless selector.nil?
          result = content.css(selector)
          result = object.send(options[:parser], result) unless options[:parser].nil?

          result = result.map { |node| type.new.bind node } unless result.nil?
        end
        result
      end

    end
  end
end

