require_relative '../config/environment'

class CLI

  def call
    puts "Hi! Welcome to the New York Times CLI."

    query = ''
    while query != "exit"
      puts "Please enter a topic that you would like to explore or 'exit':"
      query = gets.strip
      if query  == 'exit'
        break
      end
      data = search(query)
      create_articles(data)
      puts render_articles
      article_index = 1

      while article_index != 0 && article_index <= Article.all.count
        puts "Please enter the number of the article you wish to read more about or 'exit':"
        article_index = gets.strip.to_i
        article = Article.all[article_index - 1]
        puts article.snippet
      end
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

  def render_articles
    articles = Article.all.last(10)

    list = articles.map.with_index(1) do |article, i|
      "#{i}. #{article.headline}"
    end
    list.flatten
  end

end
