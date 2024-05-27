require 'liquid'
require 'yaml'
require './lib/rss_writer'

class Builder
  def build
    @articles = Article.load_articles.sort! { |a,b| a.date <=> b.date }.reverse!

    @articles.each do |a|
      template = Liquid::Template.parse(File.read(blog_template_file))
      rendered = template.render(
        'date' => a.formatted_date,
        'title' => a.title,
        'body' => a.body_to_html,
        'image_url' => a.image_url
      )

      File.open("public/#{a.output_file_name}", "w") { |f| f.puts rendered }
    end

    cards = @articles.map do |a|
      template = Liquid::Template.parse(File.read(card_template_file))
      template.render(
        'image_url' => a.image_url,
        'title' => a.title,
        'date' => a.formatted_date,
        'link_url' => a.output_file_name
      )
    end

    template = Liquid::Template.parse(File.read(index_template_file))
    rendered = template.render('cards' => cards)
    File.open(index_output_file, "w") { |f| f.puts rendered }

    rss = RssWriter.new
    rss.write
  end

  private
  def blog_template_file
    "template/blog.html.liquid"
  end

  def index_template_file
    "template/index.html.liquid"
  end

  def card_template_file
    "template/card.html.liquid"
  end

  def index_output_file
    "public/index.html"
  end
end

Builder.new.build

