module Consequence
  describe Failure do
    let(:methods) { Methods.new }

    describe '#>>' do
      it 'does not call method and remains unchanged' do
        expect(methods).to_not receive(:increment)
        expect(Failure[0] << methods.method(:increment)).to eq(Failure[0])
      end
    end

    describe '#<<' do
      it 'does not call method and there are no side effects' do
        expect(methods).to_not receive(:log)
        Failure[0] >> methods.method(:log)
        expect(methods.side_effect).to eq(nil)
      end
    end

    describe '#succeeded?' do
      it { expect(Failure[0].succeeded?).to be(false) }
    end

    describe '#failed?' do
      it { expect(Failure[0].failed?).to be(true) }
    end
  end
end
