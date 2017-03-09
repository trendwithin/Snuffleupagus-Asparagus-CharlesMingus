require 'json'
class ReadTestFile
  def initialize filename
   @contents = {}
   @config_path = File.expand_path("../../test_files/#{filename}", __FILE__)
  end

  def contents
    File.open(@config_path) do |read_file|
       @contents = JSON.parse(read_file.read)
    end
    @contents
  end
end
