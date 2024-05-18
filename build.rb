require 'liquid'
require 'yaml'

class Builder
  def build
    Dir.each_child("blog") do |b|
      data = YAML.safe_load(File.read("blog/#{b}"), permitted_classes: [Date, Symbol])

      template = Liquid::Template.parse(File.read(blog_template))
      rendered = template.render(
        'date' => data[:date].strftime("%b. %d, %Y"),
        'title' => strip_quotes(data[:title]),
        'diary' => to_paragraphs(data[:diary_block]),
        'review' => to_paragraphs(data[:review_block]),
        'image_url' => image_url
      )

      File.open(blog_file_name(data), "w") { |f| f.puts rendered }
    end
  end

  private
  def blog_template
    "template/blog.html.liquid"
  end

  def blog_file_name data
    "public/blog-#{data[:date].strftime('%Y%m%d')}.html"
  end

  def strip_quotes text
    text =~ /^["「《](.+)["」》]$/ ? $1 : text
  end

  def to_paragraphs text
    text.split("\n\n").map { |t| "<p>#{t}</p>" }.join
  end

  def image_url
    "images/cafe-#{rand(27)}.jpeg"
  end
end

Builder.new.build

