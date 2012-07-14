shared_examples_for 'storage' do
  context '.establish_connection' do
    it 'should connect to storage' do
      storage.should_not be_nil
    end
  end

  describe '#state' do
    context 'when new position' do
      subject { position.state }
      it { should equal :create}
    end

    context 'when modify position' do
      before do
        position.save
        position.checksum = 1
      end

      after { position.destroy }

      subject { position.state }
      it { should equal :update}
    end

    context 'when exist position' do
      before { position.save }
      after { position.destroy }
      subject { position.state }
      it { should equal :unmodified}
    end

    context 'when position without state' do
      let(:position) { PositionWithoutState.new name: 'test'}
      subject { position.state }
      it { should equal :create}
    end
  end

  describe '#refresh' do
    def refresh state
      storage.should_receive(state).with(position)
      storage.refresh(position, state)
    end

    context 'when new position' do
      it 'then create it' do
        refresh :create
      end
    end

    context 'when modify position' do
      it 'then update it' do
        refresh :update
      end
    end

    context 'when old position' do
      it 'then delete it' do
        refresh :remove
      end
    end
  end

  describe '#create' do
    before { position.save }
    after { position.destroy }

    it 'sould create position' do
      storage.find(position).should_not be_nil
    end

    it 'set position id' do
      position.id.should_not be_nil
    end
  end

  describe '#update' do
    before do
      position.save
      position.checksum = '1'
      position.save
    end
    after { position.destroy }

    it 'should update position' do
      storage.find(position)['checksum'].should eql '1'
    end
  end

  describe '#remove' do
    before do
      position.save
      position.destroy
    end

    after { position.destroy }

    it 'should remove position' do
      storage.find(position).should be_nil
    end
  end
end