class TableCopier
  TABLE_NAME = "Table1"

  def perform
    records = copy_records
    save_records_to_file(records)
  end

  private

  def copy_records
    client = Airtable::Client.new(ENV['AIRTABLE_API_KEY'])
    table = client.table(ENV['AIRTABLE_APP_KEY'], TABLE_NAME)
    table.records
  end

  def save_records_to_file(records)
    copy_data = records.map{ |record| [record[:key], record[:copy]] }.to_h
    File.write('public/copy.json', copy_data.to_json)
  end
end
