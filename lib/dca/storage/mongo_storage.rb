module DCA
  class MongoStorage
    attr_reader :database, :collection

    def initialize(connection, context, options = {})
      @database = connection.db(options[:database] || DCA.project_name.underscore)
      @connection = connection
      @collection = database.collection(options[:collection] || get_alias(context))
    end

    def self.establish_connection(config)
      Mongo::Connection.new config[:host], config[:port]
    end

    def state(position)
      item = find position
      return :create if item.nil?

      position.id = item['_id']
      return :unmodified if item['checksum'] == position.checksum

      return :update
    end

    def find position
      collection.find_one base_id: position.base_id unless position.base_id.nil?
    end

    def refresh(item, state)
      send state, item
    end

    def create(item)
      item.id = collection.insert hash_from item
    end

    def update(item)
      collection.update({_id: item.id}, hash_from(item))
    end

    def remove(item)
      collection.remove _id: item.id
    end

    def context object
      result = self.clone
      result.instance_variable_set :@collection, result.database.collection(get_alias object)
      result
    end

    private

    def hash_from(item)
      data = item.to_hash
      data.delete(:id)
      data
    end

    def get_alias object
      object.respond_to?(:alias) ? object.alias : object.to_s.demodulize.downcase.pluralize
    end
  end
end