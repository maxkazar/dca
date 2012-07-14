module DCA
  module Mock
    class FileStorage

      attr_reader :collection

      def initialize(connection, context, options = {})
        @collection = DCA.project_name
        @states = YAML.load_file('./spec/fixtures/states.yml')
      end

      def self.establish_connection(config)
      end

      def state(position)
        @states[position.id].to_sym
      end

      def refresh(position, state)

      end

      def context object
        self.clone
      end
    end
  end
end