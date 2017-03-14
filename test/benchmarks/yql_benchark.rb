require 'benchmark'
require_relative '../helpers/read_test_file'
require_relative '../../lib/yql_extraction'

# Read File Contents
filename = 'yql_response.json'
data = ReadTestFile.new(filename).contents

# YqlExtraction
@yql = YqlExtraction.new
@time = 0.0

n = 10_000
@time = 0.0
n.times do |x|
  @time += Benchmark.realtime do
    arr = @yql.parse_queried_json(data, "query", "results", "quote")
    volume = @yql.request_arg_data_from arr, "Volume"
  end
end

puts @time

@time = 0.0
n = 1000
n.times do |x|
  values = []
  @time += Benchmark.realtime do
    arr = @yql.parse_queried_json(data, "query", "results", "quote")
    arr.map! do |x|
      Hash[x.map { |(k,v)| [k.to_sym,v]}]
    end
    arr.map { |e| values << e[:Volume].to_i }
  end
end

puts @time
