module DCA
  module Jobs
    class Job
      include Helpers::Logger
      logger_name :queue

      attr_reader :options

      def self.queue
        self.to_s.split("::")[-2]
      end

      # Add a job to queue. Queue name is a class module name
      def self.create(options={})
        Resque.enqueue(self, options)
      end

      def self.perform(options={})
        instance = new options.symbolize_keys!
        instance.safe_perform!
        instance
      end

      def initialize(options = {})
        @options = options

        trap('QUIT') { shutdown }
      end

      def safe_perform!
        perform
        on_success if respond_to?(:on_success)
      rescue Exception => exception
        if respond_to?(:on_failure)
          on_failure(exception)
        else
          raise exception
        end
      ensure
        destroy
      end

      def perform
        raise NotImplementedError
      end

      def destroy

      end

      def shutdown?
        @shutdown
      end

      private

      def shutdown
        @shutdown = true
      end
    end
  end
end