#!/usr/bin/ruby -KuU
# encoding: utf-8

# Given a stoplist for a particular language and a text
# file written in that language, print a frequency list of 
# the most "salient" or interesting high frequency words
#
# Usage:
# ruby salient.rb [iso_language_code] frequency_list.txt
# (process a frequency list directly)
# OR
# ruby file_freq.rb somefile.txt | ruby salient.rb
# (process any text file using a pipe)

require 'json'
require 'optparse'

# Stoplist configuration
stoplist_dir = ""
# A directory containing stoplists in json format needs to 
# be specified here
# A good example with a wide selection of languages can be 
# found in the "dist" folder of the stopwords project:
# https://github.com/6/stopwords

lang = ""
# the iso code of the language for the stoplist you want
# to use

# parse command-line options
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-l", "--language CODE", "Language code to use for processing") { |v| options[:language] = v }
  opts.on("-s", "--stoplist-dir DIR", "Directory containing stoplist files") { |v| options[:stoplist_dir] = v }

end.parse!

if options[:language]
  lang = options[:language]
end
if options[:stoplist_dir]
  stoplist_dir = options[:stoplist_dir]
end

file_content = ARGF.read

stopwords_file = File.read(stoplist_dir + lang + ".json")
json = JSON.parse(stopwords_file)

filtered_list = []

file_content.each_line do |line|
  freq,keyword = line.chomp.split("\t")
  if !json.include?(keyword)
    filtered_list.push(freq + "\t" + keyword)
  end
end

puts filtered_list
