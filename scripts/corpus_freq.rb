#!/usr/bin/ruby -KuU
# encoding: utf-8

# Print frequency list for all texts in a given folder.
# Tailored for use with the texts from the ASP corpus:
# https://github.com/global-asp/asp-source
#
# Usage: ruby corpus_freq.rb [path/to/directory]

dir = ARGV[0]
dir = dir.gsub(/([^\/])$/, "\\1/")

files = Dir.glob(dir + "*")

corpus = ""

files.each do |filename|
  if File.basename(filename) == "README.md" then next end
  file_content = File.read(filename)
  story_content = file_content.gsub(/##\n\* License: .*/m, "")
  corpus << story_content + "\n"
end

freq = Hash.new(0)

# regex for strings that are words
# can't just be \w+ for most languages
words_re = /[^\n\s$0-9”“"\.,\!\?\(\)\[\]#&~`‘’:;<>–…´\*\/]+/

corpus.scan(words_re).each do |w|
#   remove extraneous apostrophes and hyphens
#   we want to keep the ones that are
#   integral parts of actual words
  w = w.gsub(/''+|'$|\s+'\s+|\-\-+|^\-|\-$|\s+\-\s+/, "").downcase
#   but don't touch "'n" (af)
  unless w == "'n"
    w = w.gsub(/^'/, "")
  end
  if w != ""
    freq[w] += 1
  end
end

output = ""
freq.keys.sort.each {|k| output << freq[k].to_s + "\t" + k + "\n"}
puts output.split("\n").sort_by{|f| f.split("\t")[0].to_i }.reverse
