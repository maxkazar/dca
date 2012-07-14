module DCA
  module Mock
    class NotifyObject
      def session
        'test_session'
      end

      def self.queue
        'test_queue'
      end
    end
  end
end