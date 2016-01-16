#!/usr/bin/ruby -KuU
# encoding: utf-8

# Print corpus statistics for specified corpus

def corpus_stats(dir, corpus)
#   some stats about the corpus
  dir = dir.gsub(/([^\/])$/, "\\1/")
  dir_name = File.split(dir)[1]
  format_output = ""

#   total number of files in the corpus
  all_files = Dir.glob(dir + "*")
  files_count = all_files.length

#   total number of words in the corpus
  words_count = corpus.split(" ").length
  avg_words_file = words_count / files_count

#   total number of lines in the corpus
  lines_count = corpus.split("\n").length
  avg_lines_file = lines_count / files_count

#   total number of words in the frequency file
  freq_list = frequency_list(corpus)
  freq_count = freq_list.length
  top_five = freq_list[0..5]
  top_five_print = top_five.join(", ").gsub(/(\d+)\t([^,]+)/, "\\2 (\\1)")
  density = ""
  top_five.each do |t|
    f, w = t.split("\t")
    d = f.to_f / words_count.to_f * 100.0
    density << "#{w} (#{f} - #{d.round.to_s}%), "
  end
#   top_five.each { |t| f = t.scan(/(\d+)\t/); d = f.to_f / words_count; density << d.round }
#   top_five_density = 
  bottom_five = freq_list[freq_count - 5..freq_count].join(", ").gsub(/(\d+)\t([^,]+)/, "\\2 (\\1)")

  longest_file_words = 0
  longest_file_words_name = ""
  shortest_file_words = avg_words_file
  shortest_file_words_name = ""
  longest_file_lines = 0
  longest_file_lines_name = ""
  shortest_file_lines = avg_lines_file
  shortest_file_lines_name = ""
  longest_line = 0
  shortest_line = 0
  total_pages = []
  longest_file_pages = 0
  longest_file_pages_name = ""
  shortest_file_pages = 1000
  shortest_file_pages_name = ""
#   avg_line_length = 0
#   avg_word_length = 0
#   word_density = 0
#   longest_word = 0
#   shortest_word = 0
#   unique_word_count = 0

  all_files.each do |f|
    if File.basename(f) == "README.md" then next end
    raw_text = File.read(f)

    length_pages = raw_text.split("##").length - 2
    total_pages.push(length_pages)

    file_content = raw_text.gsub(/##\n\* License: .*/m, "").gsub(/#+\n+/, "")
    length_words = file_content.split(" ").length
    length_lines = file_content.split("\n").length - 2
    if length_words > longest_file_words
      longest_file_words = length_words
      longest_file_words_name = File.basename(f)
    end
    if length_lines > longest_file_lines
      longest_file_lines = length_lines
      longest_file_lines_name = File.basename(f)
    end
    if length_pages > longest_file_pages
      longest_file_pages = length_pages
      longest_file_pages_name = File.basename(f)
    end
    if length_words < shortest_file_words
      shortest_file_words = length_words
      shortest_file_words_name = File.basename(f)
    end
    if length_lines < shortest_file_lines
      shortest_file_lines = length_lines
      shortest_file_lines_name = File.basename(f)
    end
    if length_pages < shortest_file_pages
      shortest_file_pages = length_pages
      shortest_file_pages_name = File.basename(f)
    end
  end

  avg_pages_file = total_pages.inject(:+).to_f / total_pages.size

  format_output << "# Corpus Statistics\n"
  format_output << "\n## General information about the #{dir_name} corpus\n"
  format_output << "* Total number of files in the corpus: `" + files_count.to_s + "`\n"
  format_output << "\n## Words\n"
  format_output << "* Total number of words in the corpus: `" + words_count.to_s + "`\n"
  format_output << "* Average number of words per file: `" + avg_words_file.to_s + "`\n"
  format_output << "* Longest file in corpus (words): `" + longest_file_words.to_s + "` (" + longest_file_words_name + ")\n"
  format_output << "* Shortest file in corpus (words): `" + shortest_file_words.to_s + "` (" + shortest_file_words_name + ")\n"
#   format_output << "* Top 5 most common words in corpus: `" + top_five_print + "`\n"
  format_output << "* Top 5 most common words in corpus: `" + density.gsub(/,\s+$/, "") + "`\n"
  format_output << "* Top 5 least common words in corpus: `" + bottom_five + "`\n"
  format_output << "\n## Lines\n"
  format_output << "* Total number of lines in the corpus: `" + lines_count.to_s + "`\n"
  format_output << "* Average number of lines per file: `" + avg_lines_file.to_s + "`\n"
  format_output << "* Longest file in corpus (lines): `" + longest_file_lines.to_s + "` (" + longest_file_lines_name + ")\n"
  format_output << "* Shortest file in corpus (lines): `" + shortest_file_lines.to_s + "` (" + shortest_file_lines_name + ")\n"
  format_output << "* Total number of lines in the frequency file: `" + freq_count.to_s + "`\n"
  format_output << "\n## Pages (ASP only)\n"
  format_output << "* _Note: Page numbers exclude front and back cover_\n"
  format_output << "* Average number of pages per story: `" + avg_pages_file.round.to_s + "`\n"
  format_output << "* Longest file in corpus (pages): `" + longest_file_pages.to_s + "` (" + longest_file_pages_name + ")\n"
  format_output << "* Shortest file in corpus (pages): `" + shortest_file_pages.to_s + "` (" + shortest_file_pages_name + ")\n"

  File.open("corpus_stats-#{dir_name}.md", "w") { |f| f << format_output }
end
