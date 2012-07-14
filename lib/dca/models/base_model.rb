module DCA
  module Models
    class BaseModel
      extend  ActiveModel::Naming
      extend  ActiveModel::Translation
      include ActiveModel::Validations
      include ActiveModel::Conversion
      include ActiveModel::Serialization
      include Binder
      include DCA::Storage

      establish_connection

      set_callback :validate, :before, :validate_associations

      attr_accessor :id, :base_id, :created_at, :updated_at

                    def initialize(params={})
        params.each { |attr, value| self.instance_variable_set "@#{attr}", value } if params
      end

      def persisted?
        true
      end

      def to_hash
        include = []
        self.class.associations(true).each { |field, options| include << field.to_s}
        self.serializable_hash include: include
      end

      def attributes
        return @attributes unless @attributes.nil?

        @attributes = Hash[instance_variables.map { |var| [var.to_s.delete('@'), instance_variable_get(var)]}]
        @attributes.delete 'errors'
        @attributes.delete 'validation_context'

        @attributes
      end

      def before_update
        self.updated_at = Time.now.utc
      end

      def before_create
        self.created_at = Time.now.utc
      end

      def validate_associations
        self.class.associations.each do |field, options|
          object = self.send(field)
          next if object.nil?

          if object.is_a? Array
            object.each { |item| validate_child item, field }
          else
            validate_child object, field
          end
        end
      end

      private

      def validate_child object, field
        if object.respond_to?(:invalid?) && object.invalid?
          self.errors.add field, object.errors.full_messages
        end
      end

    end
  end
end