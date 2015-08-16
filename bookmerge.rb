# require 'mechanize'
# mechanize = Mechanize.new
# text1 = mechanize.get('http://www.gutenberg.org/files/12/12-h/12-h.htm')
# puts text1.title
# I'd like to use Mechanize but Gutenberg doesn't have support for "non-human"
# users, so keeping this on the backburner for now.


require 'markov_chains'
require 'sinatra'
require './corpus.rb'

set :public_folder, File.dirname(__FILE__) + '/static'
enable :logging
enable :sessions

$mycorpus = Corpus.new
$generators = Hash.new

def add_text_to_corpus(text, corpus=nil)
  corpus ||= $mycorpus
  corpus.clearusertext
  corpus.addtext(text)
  return corpus
end

## Original bookmerge.rb logic is more or less in here:
def get_generator(text1, text2, corpus=nil)
  corpus ||= $mycorpus
  wholetext = combine_texts(text1, text2, corpus)
  # Sort given texts alphabetically to generate ID since they're order-agnostic.
  texts = [text1, text2].sort
  generator_id = "#{texts[0].gsub(/\s+/, "")}_and_#{texts[1].gsub(/\s+/, "")}".downcase.to_sym
  # Either take the existing generator, or create a new one and store it.
  $generators[generator_id] ||=  MarkovChains::Generator.new(wholetext)
end

get '/' do
  erb :index, :locals => {:corpus => $mycorpus}
end

# Return a plaintext sentence from the combined texts
post '/displaytext' do
  text1, text2, usertext = params[:text1], params[:text2], params[:usertext]
  begin
    if text1 == 'User generated text'
      add_text_to_corpus(usertext, corpus=nil)
    elsif text2 == 'User generated text'
      add_text_to_corpus(usertext, corpus=nil)
    end
    get_generator(text1, text2).get_sentences(1)
  rescue Exception => err
    p "Something has gone wrong: #{err}"
    nil
  end
end
