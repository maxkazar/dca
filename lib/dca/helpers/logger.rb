module DCA
  module Helpers
    class VerboseLogger < ::Logger

      def initialize(logdev, shift_age = 0, shift_size = 1048576, verbose = false)
        super logdev, shift_age, shift_size
        @verbose_logdev = LogDevice.new(STDOUT, :shift_age => shift_age, :shift_size => shift_size) if verbose
        @default_logdev = @logdev
      end

      def add(severity, message = nil, progname = nil, &block)
        super severity, message, progname, &block

        if @verbose_logdev
          @logdev = @verbose_logdev
          super severity, message, progname, &block
          @logdev = @default_logdev
        end
      end

      def exception(error, progname = nil, &block)
        add(FATAL, "#{error.message}\n#{error.backtrace.join("\n")}", progname, &block)
      end
    end

    module Logger
      extend ActiveSupport::Concern

      module ClassMethods
        def logger_name name
          define_method :logger do
            @logger unless @logger.nil?

            out = APP_CONFIG[:logger] ? File.join(DCA.root, 'log', "#{(self.class.send name).underscore}.log") : NIL
            @logger ||= VerboseLogger.new out, 0, 1048576, APP_CONFIG[:verbose]
          end
        end

        def logger= value
          @logger = value
        end
      end

      def logger
        self.class.logger
      end

    end
  end
end