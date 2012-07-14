module DCA
  module Redis
    class AnalyzeNotify < Ohm::Model
      attribute :state # create, update, unchange, failed

      index :state

      counter :count
      #reference :session, Session
    end
  end
end