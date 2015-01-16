module Consequence
  describe DelegatesToValue do
    before do
      stub_const('Foo', Class.new(Monad))
      stub_const('Bar', Class.new(NullMonad))
      Foo.include DelegatesToValue
      Bar.include DelegatesToValue
    end

    describe '#method_missing' do
      it 'delegates to value for monads' do
        expect(Foo[[1, 4, 5]].pop).to eq(Foo[5])
      end

      it 'ignores without error for null monads' do
        expect(Bar[[1, 4, 5]].pop).to eq(Bar[[1, 4, 5]])
      end
    end

    describe '#respond_to_missing?' do
      it 'is true for methods that value responds to' do
        expect(Foo[[]].respond_to?(:pop)).to be(true)
      end
    end
  end
end
