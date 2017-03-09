class YqlExtraction

  def request_arg_data_from arr, arg
    values = []
    arr.map { |e| values << e["#{arg}"].to_i }
    values
  end

  def current_value_is_maximum?(arr)
    arr.max == arr.last
  end

  def parse_queried_json json, *args
    json.dig(*args)
  end
end
