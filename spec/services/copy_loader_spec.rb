require 'rails_helper'

RSpec.describe CopyLoader, type: :service do
  let(:service) { CopyLoader.new }

  describe '#perform' do
    it 'returns empty with exception' do
      allow(File).to receive(:read).and_raise(StandardError)
      expect(service.perform).to eq({})
    end

    it 'returns empty with empty file' do
      allow(File).to receive(:read).and_return('')
      expect(service.perform).to eq({})
    end

    it 'returns data' do
      data = {'a' => 'b'}
      expect(File).to receive(:read).and_return(data.to_json)
      expect(service.perform).to eq(data)
    end
  end
end
