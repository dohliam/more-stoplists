#!/usr/bin/ruby -KuU
# encoding: utf-8

# Print ordered list of words in a given file by their 
# frequency.
#
# Usage:
# Reads from a file specified as an argument or standard 
# input.

file_content = ARGF.read

words_re = /[^\n\s$0-9”“"\.,\!\?\(\)\[\]#&~`‘’:;<>–…´\*\/]+/

freq = Hash.new(0)
file_content.scan(words_re) {|w| freq[w.downcase] += 1}
a = ""
freq.keys.sort.each {|k| a << freq[k].to_s + "\t" + k + "\n"}
puts a.split("\n").sort_by{|f| f.split("\t")[0].to_i }.reverse
