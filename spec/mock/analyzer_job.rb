module DCA
  module Mock
    class AnalyzerJob < DCA::Jobs::AnalyzerJob

      def positions(&block)
        positions = YAML.load_file(options[:fixture])
        positions.each { |position| block.call Position.new position.symbolize_keys }
      end

      def fetch(position)
        raise Exception if position.raise
        position.failed ? nil : position
      end
    end
  end

  module Areas
    module Mock
      class AnalyzerJob < DCA::Jobs::AnalyzerJob
        def perform
          loop do
            break if shutdown?
          end
        end
      end
    end
  end
end


