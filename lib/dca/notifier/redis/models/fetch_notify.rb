module DCA
  module Redis
    class FetchNotify < Ohm::Model
      attribute :state

      index :state

      counter :success
      counter :failure
      #attribute :message
      #attribute :stack
      #reference :session, Session
    end
  end
end