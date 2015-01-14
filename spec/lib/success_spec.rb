module Consequence
  describe Success do
    let(:methods) { Methods.new }

    describe '#>>' do
      context 'for a method that raises exception' do
        it 'it returns a Failure' do
          result = Success[5] >> methods.method(:dangerous)
          expect(result).to be_instance_of(Failure)
          expect(result.value).to be_instance_of(ArgumentError)
        end
      end

      context "for a method that doesn't raise exception" do
        it 'returns a Success with an updated value' do
          expect(Success[0] >> methods.method(:dangerous)).to eq(Success[5])
        end
      end
    end

    describe '#<<' do
      context 'for a method that raises exception' do
        it 'it returns a Failure' do
          result = Success[5] << methods.method(:dangerous)
          expect(result).to be_instance_of(Failure)
          expect(result.value).to be_instance_of(ArgumentError)
        end
      end

      context "for a method that doesn't raise exception" do
        it 'returns a Success that is unchanged' do
          expect(Success[0] << methods.method(:dangerous)).to eq(Success[0])
        end
      end
    end

    describe '#succeeded?' do
      it { expect(Success[0].succeeded?).to be(true) }
    end

    describe '#failed?' do
      it { expect(Success[0].failed?).to be(false) }
    end
  end
end
