require_relative '../test/helpers/test_helper'
require 'byebug'
require 'minitest/autorun'
require 'yql_extraction'
require 'vcr'
require 'date'
require 'json'

VCR.configure do |config|
  config.cassette_library_dir = "vcr_cassettes"
  config.hook_into :webmock
end

class YqlExtractionTest < Minitest::Test
  def setup
    symbol = 'YHOO'
    current_date = Time.now.strftime("%Y-%m-%d")
    date_lookback = (DateTime.now - 1).strftime("%Y-%m-%d")
    @url = "http://query.yahooapis.com/v1/public/yql?q="
    @select_statment = "SELECT * FROM yahoo.finance.historicaldata"
    @where_statement = " WHERE symbol =\"#{symbol}\" AND startDate =\"#{date_lookback}\" AND endDate =\"#{current_date}\""
    @format = "&format=json&diagnostic=true&env=store://datatables.org/alltableswithkeys&callback="
    @yql = YqlExtraction.new
  end

  def test_response_code_200
    url = @url + @select_statment + @where_statement + @format
    VCR.use_cassette('yql_query') do
      response = Net::HTTP.get_response(URI("#{url}"))
      assert_equal "200", response.code
    end
  end

  def test_format_data_to_json
    url = @url + @select_statment + @where_statement + @format
    VCR.use_cassette('query', :serialize_with => :json) do
      response = Net::HTTP.get_response(URI("#{url}"))
      hash_response = JSON.parse(response.body)
      assert_equal Hash, hash_response.class
    end
  end

  def test_parsing_of_json_data
    filename = 'yql_response.json'
    data = ReadTestFile.new(filename).contents
    arr = @yql.parse_queried_json(data, "query", "results", "quote")
    assert_equal Array, arr.class
  end

  def test_extracted_array_returns_volume_data
    filename = 'yql_response.json'
    data = ReadTestFile.new(filename).contents
    arr = @yql.parse_queried_json(data, "query", "results", "quote")
    volume = @yql.request_arg_data_from arr, "Volume"
    assert_equal 248, volume.count
  end

  def test_maximum_value_returned
    arr = (1..252).to_a
    assert_equal true, @yql.current_value_is_maximum?(arr)
  end

  def test_maximum_value_is_not_current_value
    arr = [6, 7, 10, 3]
    assert_equal false, @yql.current_value_is_maximum?(arr)
  end
end
