module DCA
  class ElasticSearchStorage
    attr_reader :type

    def initialize(connection, context, options = {})
      @connection = connection
      @index = options[:index] || DCA.project_name.underscore
      @type = options[:type] || get_alias(context)
    end

    def self.establish_connection(config)
      RestClient.get("http://#{config[:host]}:#{config[:port]}")
      Tire.configure { url "http://#{config[:host]}:#{config[:port]}" }
    end

    def state position
      item = find position
      return :create if item.nil?

      position.id = item[:id]
      return :unmodified if item[:checksum] == position.checksum

      :update
    end

    def find position
      return nil if position.base_id.nil?
      query = Tire.search(@index, type: type) { query { term :base_id, position.base_id } }
      query.results.first
    end

    def refresh(item, state)
      send state, item
    end

    def create(item)
      item.updated_at = item.created_at = Time.now.utc
      data = hash_from item

      result = Tire.index(@index).store data
      Tire.index(@index).refresh

      item.id = result['_id']
    end

    def update(item)
      data = hash_from item
      Tire.index(@index) do
        store data
        refresh
      end
    end

    def remove(item)
      data = hash_from item

      Tire.index(@index) do
        remove data
        refresh
      end
    end

    def index(&block)
      Tire.index @index do
        instance_eval(&block) if block_given?
      end
    end

    def context object
      result = self.clone
      result.instance_variable_set :@type, get_alias(object)
      result
    end

    private

    def hash_from(item)
      data = item.to_hash
      data[:_id] = data[:id] if data[:id]
      data.delete(:id)
      data[:type] = type
      data
    end

    def get_alias object
      object.respond_to?(:alias) ? object.alias : object.to_s.demodulize.downcase.pluralize
    end
  end
end