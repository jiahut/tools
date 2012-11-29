require 'nokogiri'
require 'open-uri'
require 'uri'

def check_usage
	if ARGV.empty?
		puts "Usage: ruby dict.rb word_which_your_want_to_look_up"
		exit
	end
end

def look_up(word)
	uri = "http://dict.baidu.com/s?wd=#{word}"
	doc = Nokogiri::HTML(open(URI.escape(uri)))
	has_found = false
	means = Array.new
	####lazy evaluation####
	means.push proc{doc.css('#en-simple-means>div:first>p')},proc{doc.css('#en-net-means li')},proc{doc.css('#en-simple-means p a')}
	means.each do |mean|
	    content = mean.call
		unless content.empty?
			content.each do |node|
				puts node.text
			end
			has_found = true
			break
		end
	end
	puts "sorry,can't found any meaning about words that you just request." unless has_found
end

if $0 == __FILE__
  check_usage
  look_up ARGV.join(' ')
end
