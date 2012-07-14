require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/position', __FILE__)

include DCA::Mock

describe 'ElasticSearch storage' do
  let(:connection) { @connection ||= DCA::ElasticSearchStorage.establish_connection APP_CONFIG[:elascticseach_db] }
  let(:position) { ElasticSearchPosition.new :base_id => '0', :checksum => '0'}
  let(:storage) { @storage ||= DCA::ElasticSearchStorage.new connection, position.class, :index => 'test' }

  before :all do
    connection
    storage.index do
      create
      store :type => 'position', :base_id => '1', :checksum => '1'
      refresh
    end
  end

  after :all do
    storage.index do
      delete
      refresh
    end
  end

  it_behaves_like 'storage'
end
