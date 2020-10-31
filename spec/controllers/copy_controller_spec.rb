require 'rails_helper'

RSpec.describe CopyController, type: :controller do
  describe '#index' do
    context 'without since param' do
      it 'returns nothing' do
        @@copy_data = {}

        get :index

        json = JSON.parse(response.body)
        expect(json).to eq(nil)
      end

      it 'returns the latest copy' do
        latest = { 'greeting' => 'Hi {name}, welcome to {app}!' }
        @@copy_data = { 'latest' => latest }

        get :index

        json = JSON.parse(response.body)
        expect(json).to eq(latest)
      end
    end

    context 'with since param' do
      it 'returns the since copy' do
        copy_data1 = { 'greeting' => 'Hi {name}, welcome to {app}!' }
        since = { 'greeting' => 'Hello {name}, welcome to {app}!' }
        latest = since.dup
        @@copy_data = {
          'latest' => latest,
          '1604107715' => copy_data1,
          '1604107717' => since
        }

        get :index, params: { since: 1604107716 }

        json = JSON.parse(response.body)
        expect(json).to eq(since)
      end
    end
  end

  describe 'show' do
    it 'returns greeting data' do
      latest = { 'greeting' => 'Hi {name}, welcome to {app}!' }
      @@copy_data = { 'latest' => latest }

      get :show, params: { key: 'greeting', name: 'John', app: 'Bridge' }

      json = JSON.parse(response.body)
      expect(json).to eq({ 'value' => 'Hi John, welcome to Bridge!' })
    end

    it 'returns created_at data' do
      latest = { 'intro.created_at' => 'Intro created on {created_at, datetime}' }
      @@copy_data = { 'latest' => latest }

      get :show, params: { key: 'intro.created_at', created_at: 1603814215 }

      json = JSON.parse(response.body)
      expect(json).to eq({ 'value' => 'Intro created on Tue Oct 27 03:56:55 PM' })
    end
  end

  describe 'refresh' do
    it 'refresh the copy data' do
      latest = { 'greeting' => 'Hi {name}, welcome to {app}!' }

      table_copier = double
      expect(TableCopier).to receive(:new).and_return(table_copier)
      expect(table_copier).to receive(:perform)

      copy_loader = double
      expect(CopyLoader).to receive(:new).and_return(copy_loader)
      expect(copy_loader).to receive(:perform).and_return(latest)

      get :refresh
      json = JSON.parse(response.body)
      expect(json).to eq(latest)
    end
  end
end
