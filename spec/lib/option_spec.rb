module Consequence
  describe Option do
    let(:methods) { Methods.new }

    describe '#>>' do
      context 'if not nil' do
        it 'chains the method' do
          expect(Option[0] >> methods.method(:increment)).to eq(Option[1])
        end
      end

      context 'if nil' do
        it 'ignores the method' do
          expect(Option[nil] >> methods.method(:increment)).to eq(Option[nil])
        end
      end
    end

    describe '#<<' do
      context 'if not nil' do
        it 'chains the method' do
          Option[0] << methods.method(:log)
          expect(methods.side_effect).to eq(1)
        end
      end

      context 'if nil' do
        it 'ignores the method' do
          Option[nil] << methods.method(:log)
          expect(methods.side_effect).to eq(nil)
        end
      end
    end

    describe '#nil?' do
      context 'if not nil' do
        it { expect(Option[0].nil?).to be(false) }
      end

      context 'if nil' do
        it { expect(Option[nil].nil?).to be(true) }
      end
    end
  end
end
