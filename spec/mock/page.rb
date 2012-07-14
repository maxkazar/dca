module DCA
  module Mock
    class Page < DCA::Models::BaseModel
      has_many :positions, ExtPosition, :selector => 'li'
    end


    class PageExt < DCA::Models::BaseModel
      attr_accessor :category
      has_many :positions, :selector => 'li', :polymorphic => :category, :append => true
    end
  end
end
