module DCA
  module Mock
    class WebNotifier
      def initialize config

      end

      def self.queue
        @queue ||= {}
      end

      def self.clean
        @queue = {}
      end

      def push(object, event, options)
        if event == :fetch && options[:result] == false
          failed_queue = Mock::WebNotifier.queue[:failed] ||= {}
          failed_queue[options[:state]] ||= 0
          failed_queue[options[:state]] += 1
        end
        if [:analyze, :fetch].include? event
          queue = Mock::WebNotifier.queue[event] ||= {}
          queue[options[:state]] ||= 0
          queue[options[:state]] += 1
        end
      end
    end
  end
end
