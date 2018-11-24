require_relative '../config/environment'

class CLI
  attr_reader :query

  def call
    puts "Hi! Welcome to the New York Times CLI."

    query = ''
    while query != "exit"
      puts "Please enter a topic that you would like to explore or 'exit':"
      query = gets.strip
      data = search(query)
      create_articles(data)
      puts render
    end
  end

  def search(query)
    endpoint = URI("https://api.nytimes.com/svc/search/v2/articlesearch.json")
    res = Faraday.get endpoint do |req|
       req.params['api-key'] = ENV['NYT_API_KEY']
       req.params['q'] = query
     end
     data = JSON.parse(res.body)
     results = data['response']['docs']
  end

  def create_articles(data)
    data.each do |article|
      a = Article.new(nil,nil,nil).tap do |a|
        a.headline = article['headline']['main']
        a.url = article['web_url']
        a.snippet = article['snippet']
      end
    end
  end

  def render
    articles = Article.all

    list = articles.map.with_index(1') do |article, i|
      "#{i}. #{article.headline}"
    end
    list.flatten
  end
end
