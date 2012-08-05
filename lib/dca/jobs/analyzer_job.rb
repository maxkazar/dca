module DCA
  module Jobs
    class AnalyzerJob < Job
      def session
        @session ||= options[:session] || UUID.generate(:compact)
      end

      def perform
        return on_change if change

        if options[:distributed] && options[:position]
          analyze position options[:position]
          return
        end

        index = 0
        # get list of positions and add to cache
        positions do |position|
          if options[:distributed]
            distribute position
          else
            analyze position
          end

          index += 1
          break if options[:limit] == index || shutdown?
        end
      end

      def change
        false
      end

      def distribute position
        self.class.create :distributed => true, :position => position.to_hash, session => self.session
      end

      # Return all positions or newly created or modified if possible. Some cases not possible to get newly created or
      # modified positions. In this case cache will be used to identify only newly created or modified positions.
      # Position must be a hash and should contain unique key :id and checksum for compare with cached positions and
      # identify newly created or modified
      def positions(&block)
        raise NotImplementedError
      end

      # Return position model from hash
      def position hash
        Models::Position.new hash
      end

      # Fetch newly created or modified positions
      def fetch position
        raise NotImplementedError
      end

      def on_change
        notify(:change)
      end

      def on_analyze(position, state)
        logger.debug "[#{position.class}] Analyze position base_id:#{position.base_id} checksum:#{position.checksum} state:#{state}"
        notify(:analyze, :position => position, :state => state)
      end

      def on_fetch(position, state, result)
        if result
          logger.debug "[#{position.class}] Fetch valid position id:#{position.id} base_id:#{position.base_id} state:#{state}"
        else
          logger.debug "[#{position.class}] Fetch invalid position base_id:#{position.base_id} state:#{state}"
          logger.debug "  Validation errors:\n    #{position.errors.full_messages.join("\n    ")}"
        end
        notify(:fetch, :position => position, :state => state, :result => result )
      end

      def on_failure(error)
        logger.exception error
        notify(:failure, :exception => error)
      end

      def on_success
        notify(:success)
      end

      protected

      def notify(event, options={})
        Notifier.push self, event, options
      end

      def analyze position
        state = position.state
        on_analyze position, state

        unless state == :unmodified
          new_position = fetch_safe! position

          unless new_position
            on_fetch position, state, false
          else
            position = new_position

            valid = new_position.valid?
            state = position.save if valid
            on_fetch position, state, valid
          end
        end
      rescue Exception => exception
        on_failure exception
      end

      def fetch_safe!(position)
        fetch position
      rescue Exception => exception
        on_failure exception
        false
      end
    end
  end
end