require 'byebug'
require 'minitest/autorun'
require 'yql_extraction'
require 'vcr'
require 'date'

VCR.configure do |config|
  config.cassette_library_dir = "vcr_cassettes"
  config.hook_into :webmock
end

class YqlExtractionTest < Minitest::Test
  def setup
    symbol = 'YHOO'
    current_date = Time.now.strftime("%Y-%m-%d")
    date_lookback = (DateTime.now - 365).strftime("%Y-%m-%d")
    @url = "http://query.yahooapis.com/v1/public/yql?q="
    @select_statment = "SELECT * FROM yahoo.finance.historicaldata"
    @where_statement = " WHERE symbol =\"#{symbol}\" AND startDate =\"#{date_lookback}\" AND endDate =\"#{current_date}\""
    @format = "&format=json&diagnostic=true&env=store://datatables.org/alltableswithkeys&callback="
  end

  def test_response_code_200
    url =   @url + @select_statment + @where_statement + @format
    VCR.use_cassette('yql_query') do
      response = Net::HTTP.get_response(URI("#{url}"))
      assert_equal "200", response.code
    end
  end
end

