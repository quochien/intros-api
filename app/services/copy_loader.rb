class CopyLoader
  def perform
    JSON.parse(File.read(TableCopier::FILE_PATH)) rescue {}
  end
end
