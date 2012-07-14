require 'timeout'
require File.expand_path('../spec_helper', __FILE__)

module TestModule
  class TestJob < DCA::Jobs::Job
  end

  class LoopJob < DCA::Jobs::Job
    def perform
      loop do
        sleep 1
        break if shutdown?
      end
    end
  end
end

describe 'Job' do
  it 'should get queue name from module name' do
    TestModule::TestJob.queue.should == 'TestModule'
  end

  it 'should shutdown when QUIT signal is happened' do
    job_pid = Process.fork { TestModule::LoopJob.create }
    sleep 1
    Process.kill 'QUIT', job_pid
    Timeout::timeout(1) {
      Process.waitpid job_pid
    }
  end
end
