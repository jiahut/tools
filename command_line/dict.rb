require 'nokogiri'
require 'open-uri'
require 'uri'

def check_usage
	unless ARGV.length == 1
		puts "Usage: ruby dict.rb word_which_your_want_to_look_up"
		exit
	end
end

def look_up(word)
	uri = "http://dict.baidu.com/s?wd=#{word}"
	doc = Nokogiri::HTML(open(URI.escape(uri)))
	means = Array.new
	####lazy evaluation####
	means.push proc{doc.css('#en-simple-means>div:first>p')},proc{doc.css('#en-net-means li')} 
	means.each do |mean|
	    content = mean.call
		unless content.empty?
			content.each do |node|
				puts node.text
			end
			return;
		end
	end
	puts "sorry,"
end

if $0 == __FILE__
  #check_usage
  look_up ARGV.join(' ')
end
