class CopyLoader
  def perform
    JSON.parse(File.read('public/copy.json')) rescue {}
  end
end
