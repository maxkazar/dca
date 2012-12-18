require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/analyzer_job', __FILE__)

describe 'Area rake task' do
  def pids
    pids = []
    Resque.workers.each do |worker|
      host, pid = worker.id.split(':')
      next unless host == worker.hostname
      pids << pid
    end
    pids.uniq
  end

  def workers_clean
    pids_to_kill = pids.join(' ')
    `kill -s TERM #{pids_to_kill}` unless pids_to_kill.empty?

    sleep 1 while pids.count > 0
  end

  before :all do
    Resque.inline = false
  end

  before do
    workers_clean
    Resque.remove_queue 'Mock'
  end

  after :all do
    Resque.inline = true
  end

  it 'should start area analyze work' do
    DCA::CLI.new.area 'start', 'Mock'
    sleep 2
    pids.count.should equal 1

    DCA::CLI.new.area 'stop', 'Mock'
    pids.count.should equal 0
  end

  it 'should stop area with set name' do
    DCA::CLI.new.area 'start', 'Mock'
    DCA::CLI.new.area 'start', 'OtherMock'
    sleep 2
    pids.count.should equal 2

    DCA::CLI.new.area 'stop', 'Mock'
    pids.count.should equal 1

    DCA::CLI.new.area 'stop', 'OtherMock'
    pids.count.should equal 0
  end

  it 'should start all areas when start without area name' do
    cmd = DCA::Commands::Area.new
    cmd.should_receive(:start_area).with(:Area1)
    cmd.should_receive(:start_area).with(:Area2)
    cmd.start
  end

  it 'should stop all areas when stop without area name' do
    cmd = DCA::Commands::Area.new
    cmd.should_receive(:stop_area).with(:Area1)
    cmd.should_receive(:stop_area).with(:Area2)
    cmd.stop
  end
end
