module DCA
  module Redis
    class Session < Ohm::Model
      attribute :uid
      attribute :created
      attribute :project
      attribute :area

      index :uid
      index :project
      index :area

      set :analyzed, DCA::Redis::AnalyzeNotify
      set :fetched, DCA::Redis::FetchNotify
      set :failures, DCA::Redis::FailureNotify

      def validate
        assert_present :uid
      end

      def analyze_state state
        self.analyzed.find(:state => state).first
      end

      def fetch_state state
        self.fetched.find(:state => state).first
      end

      def inc_analyze state
        notify = self.analyzed.find(:state => state).first
        if notify.nil?
          notify = AnalyzeNotify.create(:state => state)
          self.analyzed.add notify
        end
        notify.incr :count
      end

      def inc_fetch state, result
        notify = self.fetched.find(:state => state).first
        if notify.nil?
          notify = FetchNotify.create(:state => state)
          self.fetched.add notify
        end
        notify.incr result
      end

      def add_failure exception
        self.failures.add FailureNotify.create(:message => exception.message, :stack => exception.backtrace)
      end
    end
  end
end