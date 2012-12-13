require 'nokogiri'
require 'open-uri'
require 'uri'
require 'sqlite3'

def check_usage
  if ARGV.empty?
    puts "Usage: ruby dict.rb word_which_your_want_to_look_up"
    exit
  end
end

def get_db
  db_file = "#{File.realpath(__FILE__)}/../dict.sqlite3"
  ddl_first_time = nil
  unless File.exist?(db_file)
    ddl_first_time = proc{ |db|
      db.execute <<-SQL
      create table words (
        word varchar(30),
        mean varchar(100),
        count int
      );
      SQL
    }
  end
  db = SQLite3::Database.open db_file
  ddl_first_time.call(db) if ddl_first_time
  return db
end

def insert2db(word,mean)
  db = get_db
  found_word = db.execute "select * from words where word = '#{word}'"
  unless found_word.empty?
    db.execute "update words set count = ? where word = '#{word}'",found_word[0][2] + 1
  else
    db.execute 'insert into words values(?,?,?)',[word,mean,1]
  end
end

def look_up(word)
  uri = "http://dict.baidu.com/s?wd=#{word}"
  doc = Nokogiri::HTML(open(URI.escape(uri)))
  has_found = false
  word2db = [word]
  means = Array.new
  ####lazy evaluation####
  means.push proc{doc.css('#en-simple-means>div:first>p')},
             proc{doc.css('#en-net-means li')},
             proc{doc.css('#en-simple-means p a')}
  means.each do |mean|
      content = mean.call
    unless content.empty?
      content.each do |node|
        puts _tmp = node.text
        word2db << _tmp
        #Thread.new(word2db) do |word2db|
        insert2db(*word2db)
        #end
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
