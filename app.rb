require 'bundler'
Bundler.require

# Le fichier contenant la classe Scrapper est appelé
$:.unshift File.expand_path("./../lib", __FILE__) #plus besoin de préciser le path exact
require 'app/scrapper' 


# Une instance du Scrapper est appelée directement
test = Scrapper.new

# Le binding.pry permet de d'experimenter directement depuis le terminal
binding.pry

puts "end of program!"