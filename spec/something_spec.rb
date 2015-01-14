module Consequence
  describe Something do
    let(:count) { ->(v) { %w(eins zwei drei)[v] } }

    describe '#>>' do
      it 'handles nil' do
        expect(Something[4] >> count).to eq(Nothing[nil])
      end

      it 'behave normally if nil not returned' do
        expect(Something[2] >> count).to eq(Something['drei'])
      end
    end
  end

  describe Nothing do
    describe '#nil?' do
      it { expect(Nothing[nil].nil?).to be(true) }
    end
  end
end
