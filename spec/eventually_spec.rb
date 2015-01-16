module Consequence
  describe Eventually do
    let(:asynchronous) do
      ->(callback) do
        Thread.new do
          sleep 1
          callback.('hello')
        end
      end
    end

    let(:append) do
      ->(callback){ ->(v) { callback.(v << ' world') } }
    end

    describe '#>> and execute' do
      it 'hooksup the procs callbacks so that asynchronous code can be run' do
        e = Eventually[asynchronous] >> append
        thr = e.execute(->(v) { @output = v })
        thr.join
        expect(@output).to eq('hello world')
      end
    end
  end
end
