class Article
  attr_accessor :headline, :url, :snippet

  @@all = []

  def initialize(headline, url, snippet)
    @headline = headline
    @url = url
    @snippet = snippet

    @@all << self
  end

  def self.all
    @@all
  end

end
