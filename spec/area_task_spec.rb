require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/analyzer_job', __FILE__)

describe 'Area rake task' do
  def workers_clean
    `ps aux | grep -P "resque-\\d"`.split("\n").each do |line|
      pid = line.split(' ')[1].to_i
      Process.kill 'TERM', pid
    end

    sleep 1 while workers_count > 0
  end

  before :each do
    Resque.inline = false
    workers_clean
  end

  after :all do
    Resque.remove_queue 'Mock'
    Resque.inline = true
    workers_clean
    #FileUtils.rm_rf File.join(DCA.root, 'log')
  end

  def workers_count
    `ps aux | grep -P "resque-\\d"`.split("\n").count
  end

  it 'should stop area analyze work' do
    current_count = workers_count + 1
    `rake resque:work BACKGROUND=1 QUEUE=Mock`
    sleep 1
    workers_count.should equal current_count

    DCA::CLI.new.area 'stop', 'Mock'
    workers_count.should equal 0
  end

  it 'should start area analyze work' do
    DCA::CLI.new.area 'start', 'Mock'
    sleep 2
    workers_count.should equal 1
  end
end
