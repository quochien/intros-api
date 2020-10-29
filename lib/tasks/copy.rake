namespace :copy do
  desc 'copy airtable table to public/copy.json'
  task table: :environment do
    p '==== start copy ===='

    TableCopier.new.perform

    p '==== done copy ===='
  end
end
