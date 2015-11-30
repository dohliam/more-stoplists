#!/usr/bin/ruby -KuU
# encoding: utf-8

# Print frequency list for all texts in a given folder, all
# words in a file, or all text in a pipe.
# Tailored for use with the texts from the ASP corpus:
# https://github.com/global-asp/asp-source
#
# Usage:
# ruby corpus_freq.rb [path/to/directory]
# =or=
# ruby corpus_freq.rb filename.txt
# =or=
# ruby cat sometext.txt | corpus_freq.rb

require "unicode_utils/downcase"

def frequency_list(corpus)
  freq = Hash.new(0)

#   regex for strings that are words
#   can't just be \w+ for most languages
  words_re = /[^\n\s$0-9”“"\.,\!\?\(\)\[\]#&~`‘’:;<>–…´\*\/«»]+/

  corpus.scan(words_re).each do |w|
#   remove extraneous apostrophes and hyphens
#   we want to keep the ones that are
#   integral parts of actual words
    w = UnicodeUtils.downcase(w.gsub(/''+|'$|\s+'\s+|\-\-+|^\-|\-$|\s+\-\s+/, ""))
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
end

def dir_to_corpus(dir, corpus_container)
  dir = dir.gsub(/([^\/])$/, "\\1/")

  files = Dir.glob(dir + "*")

  files.each do |filename|
    if File.basename(filename) == "README.md" then next end
    file_content = File.read(filename)
    story_content = file_content.gsub(/##\n\* License: .*/m, "")
    corpus_container << story_content + "\n"
  end
end

corpus = ""

# read input from a file, directory, or pipe
if ARGV[0]
  args = ARGV[0]
  if File.directory?(args)
    dir = File.absolute_path(args)
    dir_to_corpus(dir, corpus)
    frequency_list(corpus)
  else
    file_content = File.read(args)
    frequency_list(file_content)
  end
elsif ARGF
  file_content = ARGF.read
  frequency_list(file_content)
else
  abort("  Please specify a source file or directory.")
end
