require 'open-uri'
require 'openssl'
class Capturer
  def self.download(file_name, uri)
    data = open(uri, 'User-Agent' => 'Ruby/#{RUBY_VERSION}',:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE){|f| f.read} 
    file = File.new file_name, 'w+'
    file.binmode 
    file << data 
    file.flush
    file.close
  end
end

if __FILE__ == $0
  _dir = Dir.pwd << File::SEPARATOR << "_temp"
  unless Dir.exist? _dir
    Dir.mkdir _dir
  end
  Dir.chdir _dir
  (0..124).map do |i|
    ["lide_#{ i }.jpg","https://speakerd.s3.amazonaws.com/presentations/f080c130744c01306b5122000a1c8083/slide_#{ i }.jpg"]
  end.each do |file_name,url|
    puts "downLoading... <" << url << ">"
    Capturer.download(file_name,url)
  end
end