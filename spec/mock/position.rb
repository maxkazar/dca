module DCA
  module Mock
    class MongoSearchPosition < DCA::Models::Position
      establish_connection :mongo_db
    end

    class ElasticSearchPosition < DCA::Models::Position
      establish_connection :elascticseach_db
    end

    class Position < DCA::Models::Position
      attr_accessor :raise, :failed, :title

      has_one :base_id, :integer, :selector => 'a', :attribute => :href, :regex => /(\d+)$/
      has_one :title,   :string,  :selector => 'a'
    end

    class ExtPosition < Position
      has_one :description, :string, :selector => 'span.description'
      has_one :date,        :datetime, :selector => 'span.date'
    end

    class FullPosition < Position
      has_one :base_id, :string, :selector => 'a'
    end

    class ChildPosition < DCA::Models::Position
      attr_reader :name, :test
    end

    class RootPosition < DCA::Models::Position
      has_one :one_child, :child_position
      has_many :child_position
    end

    class PositionWithoutState < DCA::Models::BaseModel
      attr_reader :name
    end
  end
end
