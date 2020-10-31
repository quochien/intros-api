require 'rails_helper'

RSpec.describe TableCopier, type: :service do
  let(:service) { TableCopier.new }

  describe '#perform' do
    before do
      allow(Time).to receive(:current).and_return('1604107716')
    end

    context 'copy data is empty' do
      it 'saves airtable data to file' do
        records = [{ key: 'greeting', copy: 'Hi {name}, welcome to {app}!' }]
        airtable_client = double
        table = double
        expect(Airtable::Client).to receive(:new).and_return(airtable_client)
        expect(airtable_client).to receive(:table).and_return(table)
        expect(table).to receive(:records).and_return(records)

        copy_loader = double
        expect(CopyLoader).to receive(:new).and_return(copy_loader)
        expect(copy_loader).to receive(:perform).and_return({})

        copy_data = {
          1604107716 => { 'greeting' => 'Hi {name}, welcome to {app}!' },
          'latest'   => { 'greeting' => 'Hi {name}, welcome to {app}!' }
        }
        expect(File).to receive(:write).with('public/copy.json', copy_data.to_json)

        service.perform
      end
    end

    context 'with updated data' do
      it 'saves airtable data to file' do
        records = [
          {
            key: 'greeting',
            copy: 'Hi {name}, welcome to {app}!'
          },
          {
            key: 'bye',
            copy: 'Goodbye'
          }
        ]
        airtable_client = double
        table = double
        expect(Airtable::Client).to receive(:new).and_return(airtable_client)
        expect(airtable_client).to receive(:table).and_return(table)
        expect(table).to receive(:records).and_return(records)

        latest_data = {
          1604107715 => { 'greeting' => 'Hi {name}, welcome to {app}!' },
          'latest'   => { 'greeting' => 'Hi {name}, welcome to {app}!' }
        }
        copy_loader = double
        expect(CopyLoader).to receive(:new).and_return(copy_loader)
        expect(copy_loader).to receive(:perform).and_return(latest_data)

        copy_data = {
          1604107715 => { 'greeting' => 'Hi {name}, welcome to {app}!' },
          'latest'   => { 'greeting' => 'Hi {name}, welcome to {app}!', 'bye' => 'Goodbye' },
          1604107716 => { 'bye' => 'Goodbye' },
        }
        expect(File).to receive(:write).with('public/copy.json', copy_data.to_json)

        service.perform
      end
    end
  end
end
