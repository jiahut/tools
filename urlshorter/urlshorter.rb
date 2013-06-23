require 'net/http'
require 'openssl'
require 'json'

def get_short_url(url)

  uri = URI('https://www.googleapis.com/urlshortener/v1/url')
  https = Net::HTTP.new(uri.host,uri.port)
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_NONE
  req = Net::HTTP::Post.new(uri.path)
  req.body = JSON.generate({longUrl: url})
  req["Content-Type"] = "application/json"
  res = https.request(req)
  json = JSON.parse(res.body)
  puts json['id']
end


if $0 == __FILE__
  puts("must asign a url ") && exit(-1) if ARGV.empty?
  get_short_url ARGV.first
end
