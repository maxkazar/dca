require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/position', __FILE__)
require File.expand_path('../mock/analyzer_job', __FILE__)
require File.expand_path('../mock/file_storage', __FILE__)
require File.expand_path('../mock/web_notifier', __FILE__)

include DCA

describe 'Analyzer jobs' do
  before :all do
    Notifier.create APP_CONFIG[:notifier]
  end

  after :all do
    Tire.index('test') do
      delete
      refresh
    end
  end

  it "should notice about analyzed positions" do
    Mock::WebNotifier.clean
    Mock::AnalyzerJob.create :fixture => './spec/fixtures/positions.yml'
    Mock::WebNotifier.queue[:analyze][:create].should equal 2
  end

  it "should notice about fetch positions" do
    Mock::WebNotifier.clean
    Mock::AnalyzerJob.create :fixture => './spec/fixtures/positions.yml'
    Mock::WebNotifier.queue[:fetch][:create].should equal 2
  end

  it "should notice about failed fetch positions" do
    Mock::WebNotifier.clean
    Mock::AnalyzerJob.create :fixture => './spec/fixtures/positions.yml'
    Mock::WebNotifier.queue[:failed][:create].should equal 1
  end

  it "should fetch only newly created and modified position" do
    Mock::WebNotifier.clean
    Mock::AnalyzerJob.create :fixture => './spec/fixtures/positions.yml'
    Mock::WebNotifier.queue[:analyze][:unmodified].should equal 1
    Mock::WebNotifier.queue[:fetch][:create].should equal 2
  end

  it "should fetch next position even if exception occurs" do
    Mock::WebNotifier.clean
    Mock::AnalyzerJob.create :fixture => './spec/fixtures/positions_with_error.yml'
    Mock::WebNotifier.queue[:failed][:create].should equal 1
  end

  it "should analyzed only limit count of posiotions" do
    Mock::WebNotifier.clean
    Mock::AnalyzerJob.create :limit => 1, :fixture => './spec/fixtures/positions.yml'
    Mock::WebNotifier.queue[:analyze][:create].should equal 1
  end

  it "should support distribute analyze" do
    Mock::WebNotifier.clean
    Mock::AnalyzerJob.create :fixture => './spec/fixtures/positions.yml', :distributed => true
    Mock::WebNotifier.queue[:analyze][:unmodified].should equal 1
    Mock::WebNotifier.queue[:fetch][:create].should equal 2
  end
end
