require_relative 'config/environment'

class App

  attr_reader :query

  def initialize(query)
    @query = query
  end

  def search
    endpoint = URI("https://api.nytimes.com/svc/search/v2/articlesearch.json")
    res = Faraday.get endpoint do |req|
       req.params['api-key'] = ENV['NYT_API_KEY']
       req.params['q'] = @query
     end
     result = JSON.parse(res.body)
     results = result['response']['docs']
  end

  def render_results
    results = self.search
    list = results.map do |result, i|
      "• #{result['snippet']}"
    end
    list.flatten
  end
end
