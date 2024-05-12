require './open_ai_api'
require 'json'
require 'liquid'

API_KEY = ARGV[0]

gpt = OpenAi.new(API_KEY, <<"EOS")
あなたは30代の女性、カフェ巡りが趣味です。おしゃれなカフェを見つけるのが得意です。
EOS

gpt.chat_completion(<<"EOS")
文京区にあるカフェに行きました。カフェで頼んだものは何ですか？またカフェではどんなことがありましたか？
EOS

gpt.chat_completion(<<"EOS")
カフェの名前を教えて下さい。これは文京区に存在する架空のカフェです。
ちょっと変な名前にしてください。
EOS

gpt.chat_completion(<<"EOS")
カフェの長所と短所を教えて下さい。
EOS

diary = gpt.chat_completion(<<"EOS")
以上の内容から、ブログ記事を書いていきます。
まずは、ブログの前半部分となる、カフェでの出来事を中心にした日記と、カフェに行くことにした経緯の部分を書いてください。
知的さとおしゃれさを感じる表現、文章にしてください。
タイトルは不要です。"「」"は不要です。
EOS

review = gpt.chat_completion(<<"EOS")
次に、後半部分となる、カフェのレビューを書いてください。
知的さとおしゃれさを感じる表現、文章にしてください。
最後の締めくくりは、独特な表現でちょっと奇妙な雰囲気を漂わせてください。
"「」"は不要です。
EOS

title = gpt.chat_completion(<<"EOS")
最後にこのブログ記事のタイトルを考えてください。"「」"は不要です。
EOS

def strip_quotes text
  text =~ /^["「](.+)["」]$/ ? $1 : text
end

def to_paragraphs text
  text.split("\n\n").map { |t| "<p>#{t}</p>" }.join
end

@template = Liquid::Template.parse(File.read("template/blog.html.liquid"))
File.open("public/blog-#{Time.now.strftime('%Y%m%d%H%M%S')}.html", "w") do |f|
  f.puts @template.render(
    'date' => Time.now.strftime("%b. %d, %Y"),
    'title' => strip_quotes(title),
    'diary' => to_paragraphs(diary),
    'review' => to_paragraphs(review)
  )
end
