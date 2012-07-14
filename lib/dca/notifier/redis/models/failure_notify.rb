module DCA
  module Redis
    class FailureNotify < Ohm::Model
      attribute :message
      attribute :stack
    end
  end
end