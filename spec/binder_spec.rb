require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/position', __FILE__)
require File.expand_path('../mock/page', __FILE__)

include DCA

describe 'Binder' do
  it 'should bind model fields' do
    page = Mock::Page.new
    page.bind Nokogiri::HTML open('./spec/fixtures/page.html')

    page.positions.should have(3).items
    page.positions.each_with_index do |position, index|
      position.base_id.should == index + 1
      position.title.should == "Position #{index + 1}"
    end
  end

  it 'should bind polymorphic association' do
    page = Mock::PageExt.new :category => :full
    page.bind Nokogiri::HTML open('./spec/fixtures/page.html')

    page.positions.should have(3).items
    page.positions.each { |position| position.is_a?(Mock::FullPosition).should be_true }


    page = Mock::PageExt.new :category => :ext
    page.bind Nokogiri::HTML open('./spec/fixtures/page.html')

    page.positions.should have(3).items
    page.positions.each { |position| position.is_a?(Mock::ExtPosition).should be_true }
  end

  it 'should inherit binding options' do
    Mock::ExtPosition.associations.should have(4).items
    Mock::ExtPosition.associations.keys.should include(:base_id, :title, :description)
  end

  it 'should override binding options' do
    Mock::FullPosition.associations.should have(2).items
    Mock::FullPosition.associations[:base_id][:type].should == :string
    Mock::FullPosition.associations[:base_id][:options].should == { :selector => 'a' }
  end

  it 'should serializable' do
    position = Mock::ChildPosition.new name: 'position'
    position.to_hash.should have_key 'name'
  end

  it 'should serializable with child' do
    position = Mock::RootPosition.new
    position.one_child = Mock::ChildPosition.new(name: 'child_position')
    position.child_position = [Mock::ChildPosition.new(name: 'position')]

    hash = position.to_hash
    hash['one_child'].is_a?(Hash).should == true

    hash['child_position'][0].is_a?(Hash).should == true
  end

  it 'should append to has many association' do
    page = Mock::PageExt.new :category => :full
    page.bind Nokogiri::HTML open('./spec/fixtures/page.html')
    page.bind Nokogiri::HTML open('./spec/fixtures/page.html')

    page.positions.should have(6).items

  end
end
