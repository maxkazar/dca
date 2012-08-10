module DCA
  module Mock
    class Page < DCA::Models::BaseModel
      has_many :positions, ExtPosition, :selector => 'li'
    end


    class PageExt < DCA::Models::BaseModel
      attr_accessor :category
      has_many :positions, :selector => 'li', polymorphic: :category, append: true, parser: :positions_parser

      def positions_parser items
        items
      end
    end
  end
end
