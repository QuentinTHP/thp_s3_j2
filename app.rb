require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper' #plus besoin de préciser le path exact

test = Scrapper.new
puts test 

binding.pry