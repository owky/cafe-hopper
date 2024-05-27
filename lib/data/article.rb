class Article
  attr_accessor :date, :title, :body, :image_url

  def initialize(date, title, body, image_url)
    @date = date
    @title = title
    @body = body
    @image_url = image_url
  end

  def self.load_articles
    articles = []
    Dir.each_child("blog") do |file|
      data = YAML.safe_load(File.read("blog/#{file}"), permitted_classes: [Date, Symbol])
      articles << Article.new(data[:date], data[:title], data[:body], data[:image_url])
    end
    articles
  end

  def file_name
    "blog-#{@date.strftime('%Y%m%d')}.html"
  end

  def time
    hour = (date.year + date.strftime('%d%m%d').to_i) % 9
    minute = (date.year + date.strftime('%d%m%d').to_i) % 60
    Time.local(date.year, date.month, date.day, hour, minute)
  end
end
