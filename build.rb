require 'liquid'
require 'yaml'

class Builder
  def build
    index = []

    Dir.each_child("blog") do |b|
      @data = YAML.safe_load(File.read("blog/#{b}"), permitted_classes: [Date, Symbol])
      index << @data

      template = Liquid::Template.parse(File.read(blog_template_file))
      rendered = template.render(
        'date' => formatted_date,
        'title' => title_strip_quotes,
        'diary' => to_paragraphs(@data[:diary_block]),
        'review' => to_paragraphs(@data[:review_block]),
        'image_url' => image_url
      )

      File.open(blog_output_file, "w") { |f| f.puts rendered }
    end

    template = Liquid::Template.parse(File.read(card_template_file))
    cards = index.map do |i|
      @data = i
      template.render(
        'image_url' => image_url,
        'title' => title_strip_quotes,
        'date' => formatted_date,
        'link_url' => blog_output_file.delete_prefix('public/')
      )
    end

    template = Liquid::Template.parse(File.read(index_template_file))
    rendered = template.render('cards' => cards)
    File.open(index_output_file, "w") { |f| f.puts rendered }
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

  def blog_output_file
    "public/blog-#{@data[:date].strftime('%Y%m%d')}.html"
  end

  def index_output_file
    "public/index.html"
  end

  def title_strip_quotes
    @data[:title] =~ /^["「《](.+)["」》]$/ ? $1 : @data[:title]
  end

  def to_paragraphs text
    text.split("\n\n").map { |t| "<p>#{t}</p>" }.join
  end

  def image_url
    "images/cafe-#{@data[:image]}.jpeg"
  end

  def formatted_date
    @data[:date].strftime("%b. %d, %Y")
  end
end

Builder.new.build

