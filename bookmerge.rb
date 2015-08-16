
require 'markov_chains'
require 'sinatra'
require './corpus.rb'

set :public_folder, File.dirname(__FILE__) + '/static'
enable :logging
enable :sessions

$mycorpus = Corpus.new
$generators = Hash.new

def replace_user_text(text, corpus)
  corpus.clearusertext
  corpus.addtext(text)
end

## Original bookmerge.rb logic is more or less in here:
def get_generator(text1, text2, usertext, corpus=nil)
  corpus ||= $mycorpus
  if text1 == 'User generated text'
    replace_user_text(usertext, corpus)
  elsif text2 == 'User generated text'
    replace_user_text(usertext, corpus)
  end
  wholetext = combine_texts(text1, text2, corpus)
  # Sort given texts alphabetically to generate ID since they're order-agnostic.
  texts = [text1, text2].sort
  generator_id = "#{texts[0].gsub(/\s+/, "")}_and_#{texts[1].gsub(/\s+/, "")}".downcase.to_sym
  # Either take the existing generator, or create a new one and store it.
  $generators[generator_id] =  MarkovChains::Generator.new(wholetext)
end

get '/' do
  erb :index, :locals => {:corpus => $mycorpus}
end

# Return a plaintext sentence from the combined texts
post '/displaytext' do
  text1, text2, usertext = params[:text1], params[:text2], params[:usertext]
  begin
    get_generator(text1, text2, usertext).get_sentences(10)
  rescue Exception => err
    p "Something has gone wrong: #{err}"
    nil
  end
end
