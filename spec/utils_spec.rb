module Consequence
	describe Utils do
		let!(:monad_with_method) do
			Class.new(Monad) do
				def is_divisible_by?(other)
					(value % other) == 0
				end
			end
		end

		before { stub_const('Foo', monad_with_method) }

		let!(:klass) do
			Class.new do
				include Utils

				def uses_send_to_value
					Monad[2] >> send_to_value(:**, 3)
				end

				def uses_send_to_monad
					Foo[9] >> send_to_monad(:is_divisible_by?, 3)
				end
			end
		end

		describe '#send_to_value' do
			it 'passes arguments to value#send' do
				expect(klass.new.uses_send_to_value).to eq(Monad[8])
			end
		end

		describe '#send_to_monad' do
			it 'passes arguments to monad#send' do
				expect(klass.new.uses_send_to_monad).to eq(Foo[true])
			end
		end
	end
end
