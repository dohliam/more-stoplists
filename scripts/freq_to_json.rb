#!/usr/bin/ruby -KuU
# encoding: utf-8

# Format stop list as an alphabetized json array

filename = ARGV[0]

stoplist = File.readlines(filename)
json_file = File.basename(filename, ".txt") + ".json"

content = "["

stoplist.sort.each do |stop|
  content << '"' + stop.chomp + '",'
end

content = content.gsub(/,$/, "") + "]"

File.open(json_file, "w") { |f| f << content }
