# more-stoplists - stoplists for African languages generated from the ASP corpus

This project uses the [source texts provided by the African Storybook Project](https://github.com/global-asp/asp-source) as a corpus and provides a number of tools to extract frequency lists and lists of stopwords from this corpus for the 60+ languages covered by ASP.

The immediate goal is to create freely-licensed stoplists for languages that are not currently included in the [stopwords](https://github.com/6/stopwords) project, and to then submit those lists as pull requests to the upstream project.

## The problem

The [stopwords](https://github.com/6/stopwords) project currently includes stoplists for an impressive number of languages, however coverage of African languages is basically non-existent.

Surprisingly, there appear to be no freely-available (let alone freely-licensed) lists of stopwords for even major African languages like Swahili anywhere online. (Articles like [this one](http://www.ihub.co.ke/blogs/18374) and [this one](http://www.ijcaonline.org/research/volume127/number16/tesha-2015-ijca-906707.pdf) mention creating Swahili stoplists, but the lists themselves are not available online in any form.)

This was not an abstract problem, either. We wanted to filter stop words out of the ASP corpus to create lists of keywords for the [ASP Imagebank Explorer](https://github.com/dohliam/imagebank-explorer) and discovered that no existing project contained lists of stopwords for African languages. Like [others before us](http://www.ihub.co.ke/blogs/18374) we decided to create our own stoplists, but we also wanted to make them freely available so others would not have to keep reinventing the wheel this way in the future.

## A solution
Fortunately, the [African Storybook Project](http://africanstorybook.org/) has been creating and translating short- and medium-form written texts in over 60 African languages and releasing them under an open license. The full corpus of these texts has been extracted and is now available in the [ASP source](https://github.com/global-asp/asp-source) repo, which makes it possible to provide reasonably good stoplists for many languages that are not currently covered by the [stopwords](https://github.com/6/stopwords) project.

## Format

The stoplists are arranged in folders according to [ISO 639-1](http://en.wikipedia.org/wiki/ISO_639-1) or [ISO 639-3](http://en.wikipedia.org/wiki/ISO_639-3) language code. So the Swahili stoplist is in the `sw` folder, and the Yoruba stoplist is in the `yo` folder, etc.

The main file format for the lists of stopwords is the same as in the main stopwords project, i.e. a simple JSON file containing an array of all the stop words in alphabetical order. This can be found in the file `[iso_code].json`.

Several other files are also provided in each folder:

* `[iso_code].txt`: The list of stopwords in plain text format, arranged in order of frequency
* `[iso_code]_frequency_list.txt`: The full frequency list for the language based on the ASP corpus, with the number of occurrences in the left column

## Scripts

The `scripts` folder contains several tools for generating the frequency data from the corpus and formatting the JSON files. Although tailored for use with the ASP corpus, they may also be of general use.

For example, the script `corpus_freq.rb` will generate a frequency list for all the files in a specified directory. You can download the entire [ASP corpus](https://github.com/global-asp/asp-source) and run this on the individual directories yourself, or point it at any other directory of text files and get frequency lists that won't choke on Unicode.

The script `file_freq.rb` does the same thing as `corpus_freq.rb`, but works on individual files instead of directories. It could be (and may one day be) incorporated into the other script, but it is mostly provided as a legacy file, and to accommodate use with pipes (e.g. something like `cat my_directory/*.txt | ruby file_freq.rb`.

The `file_freq.rb` and `corpus_freq.rb` scripts can also be used together with `salient.rb` to create a list of the most "salient" or interesting/unusual words in a text or corpus. After configuring `salient.rb`, you can issue the following command:

    ruby file_freq.rb somefile.txt | ruby salient.rb

or

    ruby corpus_freq.rb /path/to/some/directory | ruby salient.rb

This will generate a list of the most frequent words in the text and then filter out all stopwords, which should leave only the most characteristic words from that particular text.

## Methodology

The methods used to generate lists of stopwords from the corpus are similar to those outlined in [this post](http://www.ihub.co.ke/blogs/18374), namely:

* Collect together all the available story texts/translations in a particular language from the corpus
* Remove all contextual metadata
* Convert text to lowercase
* Create frequency list from aggregated text
* Remove proper names, place names, nouns (e.g. names of animals) and other unsuitable words from the list
* Sample the top 100 or so of the most frequently-occurring words (the exact number to vary depending on the size of the corpus for that particular language and the nature of the data)

Some manual tweaking will also be necessary for most languages to accommodate various quirks of orthography and usage. For example, the indefinite article "'n" in Afrikaans can be represented by the [deprecated](http://unicode.org/udhr/n/notes_afr.html) Unicode character `ŉ` or a variety of other forms (such as `ǹ`, which appears in the corpus 5 times). Despite the fact that these are not standard forms, and that their individual frequencies may be quite low, they nevertheless represent the same stop word `'n` and can be expected to appear in general texts where people might want to filter them out. Therefore, each of these forms should be manually included in the stoplist.

## Help needed
Assistance is needed, particularly from speakers of the languages in question, to quality check the lists and make sure that only stop words have been included.

## Used in
The stopword lists provided here are currently used in (and were originally generated for) the [ASP Imagebank Explorer](https://global-asp.github.io/imagebank/). This image search application needed to filter out stop words in languages like Swahili, Afrikaans, Luganda, and Yoruba, but there were no stoplists available for any of those languages.

This project therefore attempts to fill in the gap in language coverage for African language stop lists by using the freely-available and open-licensed [ASP Source](https://github.com/global-asp/asp-source) project as a corpus.

## License
Dual-licensed under [CC-BY](https://creativecommons.org/licenses/by/3.0/) and [Apache-2.0 license](http://www.apache.org/licenses/LICENSE-2.0) to allow for easy sharing of generated data with the [stopwords project](https://github.com/6/stopwords).
