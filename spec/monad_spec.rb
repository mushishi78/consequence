module Consequence
  describe Monad do
    before(:all) do
      class Foo < Monad; end
      class Bar < Monad; end
    end

    after(:all) do
      Consequence.send(:remove_const, :Foo)
      Consequence.send(:remove_const, :Bar)
    end

    describe '#>>' do
      let(:compare)   { ->(v, m) { m == Foo[0] ? Foo[1] : Bar[v] } }
      let(:transform) { ->(v, m) { m == Foo[1] ? 10 : 3 } }
      let(:validate)  { ->(v) { v > 4 ? Bar[v] : Foo[v] } }
      let(:increment) { ->(v) { v + 1 } }
      let(:module_example) { Module.new { def self.call(v); v / 4 end } }

      it 'handles a Monad => Monad proc' do
        expect(Foo[0] >> compare).to eq(Foo[1])
      end
      it 'handles a Monad => Fixum proc' do
        expect(Foo[1] >> transform).to eq(Foo[10])
      end
      it 'handles a Fixum => Monad proc' do
        expect(Foo[10] >> validate).to eq(Bar[10])
      end
      it 'handles a Fixnum => Fixnum proc' do
        expect(Bar[10] >> increment).to eq(Bar[11])
      end
      it 'handles a Symbol proc' do
        expect(Bar[11] >> :next).to eq(Bar[12])
      end
      it 'handles objects' do
        expect(Bar[12] >> module_example).to eq(Bar[3])
      end
    end

    describe '#<<' do
      let(:react) { ->(v, m) { @side_effect = v**2 if m.bar? } }
      let(:log)   { ->(v) { @side_effect = @side_effect.to_s } }

      it 'handles a Monad => _ proc' do
        expect(Bar[12] << react).to eq(Bar[12])
        expect(@side_effect).to eq(144)
      end

      it 'handles a Fixnum => _ proc' do
        expect(Bar[12] << react << log).to eq(Bar[12])
        expect(@side_effect).to eq('144')
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

    describe 'query_method' do
      it 'defines query methods' do
        expect(Foo[0].foo?).to be(true)
        expect(Foo[0].bar?).to be(false)
        expect(Bar[0].foo?).to be(false)
        expect(Bar[0].bar?).to be(true)
        expect(Monad[0].foo?).to be(false)
        expect(Monad[0].bar?).to be(false)
      end
    end
  end

  describe NullMonad do
    describe '#>>' do
      let(:increment) { ->(v) { v + 1 } }

      it 'ignores proc' do
        expect(NullMonad[24] >> increment).to eq(NullMonad[24])
      end
    end

    describe '#<<' do
      let(:log) { ->(v) { @side_effect = v**2 } }

      it 'ignores proc' do
        expect(NullMonad[12] << log).to eq(NullMonad[12])
        expect(@side_effect).to eq(nil)
      end
    end
  end
end
