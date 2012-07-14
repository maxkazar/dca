module DCA
  module Storage
    extend ActiveSupport::Concern

    module ClassMethods
      def establish_connection config_name = :db
        @config = APP_CONFIG[config_name]
      end

      def root_storage
        return @storage if @storage

        return storage if @config

        superclass.root_storage if superclass != Object
      end

      def storage
        return @storage unless @storage.nil?

        if @config
          driver_class = "DCA::#{@config[:driver]}Storage".constantize
          connection = driver_class.establish_connection @config
          @storage = driver_class.new connection, self, @config
        else
          @storage = superclass.root_storage.context self
        end
      end
    end

    def state
      self.class.storage.state self
    end

    def save
      return false unless valid?

      current_state = state

      callback = "before_#{state}"
      send callback if self.respond_to? callback

      self.class.storage.refresh self, current_state

      callback = "after_#{state}"
      send callback if self.respond_to? callback

      current_state
    end

    def destroy
      self.class.storage.refresh self, :remove
    end
  end
end