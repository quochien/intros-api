class TableCopier
  TABLE_NAME = 'Table1'
  FILE_PATH = 'public/copy.json'

  def perform
    save_records_to_file(copy_records)
  end

  private

  def copy_records
    client = Airtable::Client.new(ENV['AIRTABLE_API_KEY'])
    table = client.table(ENV['AIRTABLE_APP_KEY'], TABLE_NAME)
    table.records
  end

  def save_records_to_file(records)
    updated_data = records.map{ |record| [record[:key], record[:copy]] }.to_h

    copy_data = CopyLoader.new.perform
    if latest_copy = copy_data['latest']
      diff_data = (updated_data.to_a - latest_copy.to_a).to_h
      copy_data[Time.current.to_i] = diff_data if diff_data.present?
    else
      copy_data[Time.current.to_i] = updated_data
    end
    copy_data['latest'] = updated_data

    File.write(FILE_PATH, copy_data.to_json)
  end
end
