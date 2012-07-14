module DCA
  module Models
    class Position < BaseModel
      attr_accessor :checksum, :published_at

      validates_presence_of :base_id, :checksum

      def initialize(*args)
        # set instance variable id, need to place this attribute to hash, when id is not set.
        @id = nil
        super
      end
    end
  end
end