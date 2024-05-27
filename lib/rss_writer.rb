require 'rss'
require './lib/data/article'
require './lib/data/blog'

class RssWriter
  RSS_FILE_NAME = "public/rss.xml"

  def initialize
    @articles = Article.load_articles
  end

  def write
    File.open(RSS_FILE_NAME, "w") { |file| file.puts build_rss.to_s }
  end

  private
  def build_rss
    RSS::Maker.make("2.0") do |maker|
      maker.channel.about = Blog::URL
      maker.channel.title = Blog::TITLE
      maker.channel.description = Blog::DESCRIPTION
      maker.channel.link = Blog::URL

      maker.items.do_sort = true

      @articles.each do |a|
        maker.items.new_item do |item|
          item.link = Blog::URL + "/" + a.output_file_name
          item.title = a.title
          item.date = a.time
        end
      end
    end
  end
end
