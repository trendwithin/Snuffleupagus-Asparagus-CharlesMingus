class YqlExtraction

  def current_value_is_maximum?(arr)
    arr.max == arr.last
  end

  def parse_queried_json json
    arr = []
    p json
  end

  def sample_method hash
    # placeholder for method to extract Volume
    hash.dig("query","results","quote","Volume")
  end
end
