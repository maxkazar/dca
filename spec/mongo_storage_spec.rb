require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/position', __FILE__)

include DCA::Mock

describe DCA::MongoStorage do
  let(:connection) { @connection ||= DCA::MongoStorage.establish_connection APP_CONFIG[:mongo_db] }
  let(:position) { MongoSearchPosition.new :base_id => '0', :checksum => '0'}
  let(:storage) { @storage ||= DCA::MongoStorage.new connection, position.class, :collection => 'test' }

  before :all do
    connection
  end

  after :all do
    connection.drop_database storage.database.name
  end

  it_behaves_like 'storage'
end
