module DCA
  module Redis
    class Notifier
      def initialize config
        Ohm.connect :url => "redis://#{config[:host]}:#{config[:port]}"
      end

      def push(object, event, options = {})
        session = Session.find(:uid => object.session, :project => DCA.project_name, :area => object.class.queue).first
        unless session.present?
          session = Session.create :uid => object.session, :created => Time.now, :project => DCA.project_name,
                                   :area => object.class.queue
        end

        if event == :analyze
          session.inc_analyze options[:state]
        elsif event == :fetch
          session.inc_fetch options[:state], options[:result] ? :success : :failure
        elsif event == :failure
          session.add_failure options[:exception]
        end
      end
    end
  end
end