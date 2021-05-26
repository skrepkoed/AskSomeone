module SearchHelper
  def search_resource(result)
    "search/#{result.class.to_s.downcase}_search"
  end
end
