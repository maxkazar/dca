require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/notify_object', __FILE__)
require File.expand_path('../mock/position', __FILE__)
require File.expand_path('../mock/file_storage', __FILE__)
require File.expand_path('../mock/analyzer_job', __FILE__)

include DCA

describe 'Redis Notifier' do

  it 'should connect to redis' do
    DCA::Notifier.create :driver => 'Redis', :host => 'localhost', :port => '6379'
    Ohm.redis.info
  end

  describe 'Instance' do
    before :all do
      DCA::Notifier.create :driver => 'Redis', :host => 'localhost', :port => '6379'
    end

    before :each do
      DCA::Redis::Session.all.each { |session| session.delete }
    end

    it 'should push analyze notify' do
      notify_object = Mock::NotifyObject.new
      DCA::Notifier.push notify_object, :analyze, :state => :create
      session = DCA::Redis::Session.find(:project => 'DCA', :area => 'test_queue', :uid => 'test_session').first
      session.analyze_state(:create).count.should equal 1

      DCA::Notifier.push notify_object, :analyze, :state => :create
      session.analyze_state(:create).count.should equal 2
    end

    it 'should push analyze notify with different state' do
      notify_object = Mock::NotifyObject.new
      DCA::Notifier.push notify_object, :analyze, :state => :create
      DCA::Notifier.push notify_object, :analyze, :state => :update
      DCA::Notifier.push notify_object, :analyze, :state => :remove
      DCA::Notifier.push notify_object, :analyze, :state => :unmodified

      session = DCA::Redis::Session.find(:project => 'DCA', :area => 'test_queue', :uid => 'test_session').first
      session.analyze_state(:create).count.should equal 1
      session.analyze_state(:update).count.should equal 1
      session.analyze_state(:remove).count.should equal 1
      session.analyze_state(:unmodified).count.should equal 1
    end

    it 'should push fetch notify' do
      notify_object = Mock::NotifyObject.new
      DCA::Notifier.push notify_object, :fetch, :state => :create, :result => true
      session = DCA::Redis::Session.find(:project => 'DCA', :area => 'test_queue', :uid => 'test_session').first
      session.fetch_state(:create).success.should equal 1

      DCA::Notifier.push notify_object, :fetch, :state => :create, :result => true
      session.fetch_state(:create).success.should equal 2

      DCA::Notifier.push notify_object, :fetch, :state => :create, :result => false
      session.fetch_state(:create).failure.should equal 1

      DCA::Notifier.push notify_object, :fetch, :state => :create, :result => false
      session.fetch_state(:create).failure.should equal 2
    end

    it 'should push analyze notify with different state' do
      notify_object = Mock::NotifyObject.new
      DCA::Notifier.push notify_object, :fetch, :state => :create, :result => true
      DCA::Notifier.push notify_object, :fetch, :state => :update, :result => true

      session = DCA::Redis::Session.find(:project => 'DCA', :area => 'test_queue', :uid => 'test_session').first
      session.fetch_state(:create).success.should equal 1
      session.fetch_state(:update).success.should equal 1
    end

    it 'should notify failure' do
      notify_object = Mock::NotifyObject.new

      begin
        raise "Test exception"
      rescue Exception => exception
        DCA::Notifier.push notify_object, :failure, :exception => exception
      end

      session = DCA::Redis::Session.find(:project => 'DCA', :area => 'test_queue', :uid => 'test_session').first
      session.failures.count.should equal 1
    end

    it 'should work with analyze job' do
      Mock::AnalyzerJob.create :fixture => './spec/fixtures/positions.yml'
      session = DCA::Redis::Session.all.first
      session.analyze_state(:create).count.should equal 2
      session.analyze_state(:unmodified).count.should equal 1

      session.fetch_state(:create).success.should equal 1
      session.fetch_state(:create).failure.should equal 1
    end
  end
end
