module Consequence
  describe Monad do
    let(:methods) { Methods.new }

    describe '#>>' do
      context 'for Monad => Monad method' do
        it 'suplies and is returned a Monad' do
          expect(Foo[0] >> methods.method(:compare)).to eq(Foo[1])
        end
      end

      context 'for Monad => Num method' do
        it 'suplies a monad and wraps return value in a monad' do
          expect(Foo[0] >> methods.method(:transform)).to eq(Foo[10])
        end
      end

      context 'for Num => Monad method' do
        it 'suplies a value and is returned a monad' do
          expect(Foo[0] >> methods.method(:validate)).to eq(Bar[0])
        end
      end

      context 'for Num => Num method (with no contract)' do
        it 'suplies a value and wraps return value in a monad' do
          expect(Foo[0] >> methods.method(:increment)).to eq(Foo[1])
        end
      end

      context 'with a symbol' do
        it 'sends the symbol to the value and wraps result in a monad' do
          expect(Foo[-1] >> :abs).to eq(Foo[1])
        end
      end
    end

    describe '#<<' do
      context 'for Any => nil method (with no contract)' do
        it 'supplies a value and the value causes side effects but leaves monad unchanged' do
          expect(Foo[0] << methods.method(:log)).to eq(Foo[0])
          expect(methods.side_effect).to eq(1)
        end
      end

      context 'for either Foo => Num or Bar => String method' do
        it 'uses supplied monad to pattern match and causes side effects' \
           'but leaves monad unchanged' do
          expect(Foo[0] << methods.method(:react)).to eq(Foo[0])
          expect(methods.side_effect).to eq(0)

          expect(Bar[1] << methods.method(:react)).to eq(Bar[1])
          expect(methods.side_effect).to eq('Bar! 1')
        end
      end

      context 'with a symbol' do
        it 'sends the symbol to the value and leaves monad unchanged' do
          expect(Foo[-1] << :abs).to eq(Foo[-1])
        end
      end
    end

    describe '#==' do
      context 'with other monad with equal value' do
        it { expect(Foo[0] == Foo[0]).to be(true) }
      end

      context 'with other monad of different value' do
        it { expect(Foo[0] == Foo[2]).to be(false) }
      end

      context 'with other a different class' do
        it { expect(Foo[0] == Bar[0]).to be(false) }
      end
    end
  end
end
