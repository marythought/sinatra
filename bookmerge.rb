# require 'mechanize'
# mechanize = Mechanize.new
# text1 = mechanize.get('http://www.gutenberg.org/files/12/12-h/12-h.htm')
# puts text1.title
# I'd like to use Mechanize but Gutenberg doesn't have support for "non-human"
# users, so keeping this on the backburner for now.


require 'markov_chains'
require 'sinatra'
require './corpus.rb'
# corpus = {
#   'The Adventures of Tom Sawyer' => 'tom_sawyer.txt',
#   'Alice in Wonderland' => 'alice_in_wonderland.txt',
#   'Anne of Green Gables' => 'anne_of_green_gables.txt',
#   'Beowulf' => 'beowulf.txt',
#   'The Bible' => 'the_bible.txt',
#   'The Brothers Grimm Fairy Tales' => 'grimms.txt',
#   'Jane Eyre' => 'jane_eyre.txt',
#   'Kama Sutra' => 'kama_sutra.txt',
#   'Little Women' => 'little_women.txt',
#   'Metamorphosis' => 'metamorphosis.txt',
#   'My Life, by Helen Keller' => 'helen_keller.txt',
#   'Peter Pan' => 'peter_pan.txt',
#   'A Picture of Dorian Gray' => 'dorian_gray.txt',
#   'Pride & Prejudice' => 'pride_and_prejudice.txt',
#   'Sherlock Holmes' => 'sherlock_holmes.txt',
#   '12 Years a Slave' => 'twelve_years_a_slave.txt',
#   'Ulysses' => 'ulysses.txt',
#   'War of the Worlds' => 'war_of_the_worlds.txt',
#   'The Wonderful Wizard of Oz' => 'wizard_of_oz.txt',
#   'The Yellow Wallpaper' => 'yellow_wallpaper.txt'
# }

set :public_folder, File.dirname(__FILE__) + '/static'
enable :logging
enable :sessions

$mycorpus = Corpus.new
$generators = Hash.new

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
  text1, text2 = params[:text1], params[:text2]
  begin
    get_generator(text1, text2).get_sentences(1)
  rescue Exception => err
    p "Something has gone wrong: #{err}"
    nil
  end
end
