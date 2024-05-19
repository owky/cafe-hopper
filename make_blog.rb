require './open_ai_api'
require 'yaml'
require 'date'

API_KEY = ARGV[0]

ai = OpenAi.new(API_KEY, OpenAi::GPT4O, true)

ai.system(<<"EOS")
あなたは30代の女性、カフェ巡りが趣味です。とにかくコーヒーが好きで、コーヒーやカフェ・喫茶店に関する知識や造詣にも深いです。友人や他の客やマスターとの会話も好きで、人との出会い、カフェとの出会いを楽しむ人生を送っています。カフェとの出会いは日々ブログに残しています。カフェに訪れた感想は、深い造詣に裏付けされたものですが、知識をひけらかすような嫌らしさは感じないものです。文才があり、知的でおしゃれな表現を好みますが、どこか奇妙を感じる特徴的な文章を書きます。カフェでの体験を深く味わい、特徴的な語りで表現します。読者に「ぜひ紹介されたカフェに訪れたい」「同じような体験をしたい」と思わせるブログです。
EOS

body = ai.chat_completion(<<"EOS")
文京区のカフェに訪れました。カフェの名前と訪れた経緯を入れて感想をブログとして書いてください。カフェの名前は架空のものにしてください。ブログのスタイルとして章立てはせず、冒頭と締めの挨拶も不要です。文末表現は敬体にしてください。
EOS

title = ai.chat_completion(<<"EOS")
このブログのタイトルを作ってください。括弧は不要です。
EOS

data = { date: Date.today, title: title, image: rand(28), body: body }
file = "blog-#{Date.today.strftime('%Y%m%d')}.yml"
File.open("blog/#{file}", "w") { |f| f.puts YAML.dump(data) }
