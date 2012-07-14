require File.expand_path('../spec_helper', __FILE__)
require File.expand_path('../mock/position', __FILE__)

include DCA

describe Models::BaseModel do
  let(:position) { Mock::RootPosition.new }
  let(:child_position) { Mock::ChildPosition.new }
  describe 'when validate has_one associations and model invalid' do
    before do
      position.one_child = child_position
      position.valid?
    end

    it 'should contains associations errors' do
      position.errors[:one_child].should_not be_nil
    end
  end

  describe 'when validate has_many associations and model invalid' do
    before do
      position.child_position = [child_position, child_position]
      position.valid?
    end

    it 'should contains associations errors' do
      position.errors[:child_position].should_not be_nil
    end

    it 'should contains associations errors array' do
      position.errors[:child_position].count.should equal 2
    end
  end
end
