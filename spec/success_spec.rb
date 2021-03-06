module Consequence
  describe Success do
    let(:dangerous) { ->(v) { 6 / v } }
    let(:type_check) { ->(v) { fail ArgumentError unless v.respond_to?(:each) } }

    describe '#>>' do
      it 'handles exceptions' do
        result = Success[0] >> dangerous
        expect(result).to be_instance_of(Failure)
        expect(result.value).to be_instance_of(ZeroDivisionError)
      end

      it 'behaves normally without exceptions' do
        expect(Success[2] >> dangerous).to eq(Success[3])
      end
    end

    describe '#<<' do
      it 'handles exceptions' do
        result = Success[0] << type_check
        expect(result).to be_instance_of(Failure)
        expect(result.value).to be_instance_of(ArgumentError)
      end

      it 'behaves normally without exceptions' do
        expect(Success[[1, 6]] << type_check).to eq(Success[[1, 6]])
      end
    end
  end
end
