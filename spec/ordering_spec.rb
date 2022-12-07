describe SimpleStates, 'ordering' do
  let(:klass) do
    create_class do
      attr_accessor :started_at, :finished_at
      event :start
      event :finish
    end
  end

  let(:obj) { klass.new }

  shared_examples_for 'accepts finish event' do
    it { expect(obj.finish).to eq true }
    it { expect { obj.finish }.to change { obj.state } }
    it { expect { obj.finish }.to change { obj.finished_at } }
  end

  shared_examples_for 'accepts start event' do
    it { expect(obj.start).to eq true }
    it { expect { obj.start }.to change { obj.state } }
    it { expect { obj.start }.to change { obj.started_at } }
  end

  describe 'both states well known' do
    describe 'in order' do
      before { obj.start }
      include_examples 'accepts finish event'
    end

    describe 'out of order' do
      before { obj.finish }
      include_examples 'accepts start event'
    end
  end

  describe 'with an unknown initial state' do
    before { obj.state = :queued }

    describe 'in order' do
      before { obj.start }
      include_examples 'accepts finish event'
    end

    describe 'out of order' do
      before { obj.finish }
      include_examples 'accepts start event'
    end
  end
end
