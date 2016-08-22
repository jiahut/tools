#!/usr/bin/env ruby

require 'unirest'
require 'digest'
require 'cgi'
require 'json'
require 'openssl'
require 'base64'

PUBLIC_KEY_FILE = 'pub.key'

def encrypt(origin_string)
  public_key = OpenSSL::PKey::RSA.new(File.read(PUBLIC_KEY_FILE))
  encrypted_string = Base64.encode64(public_key.public_encrypt(origin_string))
  encrypted_string
end


API_URL = "http://dtapp.jfpal.com/api-service/v1"
# API_URL =  "http://210.22.146.222:8092/api-service/v1"
# API_URL =  "http://192.180.2.201:8080/v1"

# response = Unirest.post "http://httpbin.org/post",
#                         headers:{ "Accept" => "application/json" },
#                         parameters:{ :age => 23, :foo => "bar" }


# p response.code # Status code
# p response.headers # Response headers
# p response.body # Parsed body
# p response.raw_body # Unparsed body
# req = '{"mobile":"18301775804","password":"qegqIHPUcCReUzcmB3cwOTmBvDvxjEKkGLzPu39vQu1C9ep0l6OuYu4shO0r0j9YxQG7wVwldyPxdPQkTZqwbsAkyvn8sIWf/I8Q619zaXJYAA+mX9bhHH6HJQBW77JB1mWS4nMzmO/x3MIvrUzZubVmwPwdJsngpyplOugayhw=","token":"0000","uuid":"a0b1907c80604f6162058a3c8035b9ef9"}'


Unirest.timeout(50) # 5s timeout

# ts = (Time.now.to_f * 1000).round
def sign(req, ts)
  md5_salt = "ifxy8jvzf1q0f9uz"
  body = "#{CGI.escape(req)}#{ts}#{md5_salt}"
  # md5.update body.upcase
  sign = Digest::MD5.hexdigest body
  sign.upcase
end

# response = Unirest.post "http://192.180.2.89:8080/api-service/v1/user/login",
#                         headers:{ "Accept" => "application/json" },
#                         parameters:{ req: req, ts: ts, sign: sign(req, ts) }

# raw_body = CGI.unescape(response.raw_body) # Unparsed body
# res, sign = raw_body.split("&")

def post(action, request)
  # dfd = Deferred.new
  req = request.to_json
  ts = (Time.now.to_f * 1000).round
  puts "POST: #{API_URL}/#{action}"
  response = Unirest.post "#{API_URL}/#{action}",
    headers:{ "Accept" => "application/json" },
    parameters:{ req: req, ts: ts, sign: sign(req, ts) }
  raw_body = CGI.unescape(response.raw_body) # Unparsed body
  unless raw_body.empty?
    res, sign = raw_body.split("&")
    JSON.parse res.split("=")[1]
    # else
    #   puts "[error] raw_body is null"
  end
end

def get(action, request)
  req = request.to_json
  ts = (Time.now.to_f * 1000).round
  puts "POST: #{API_URL}/#{action}"
  response = Unirest.get "#{API_URL}/#{action}",
    headers:{ "Accept" => "application/json" },
    parameters:{ req: req, ts: ts, sign: sign(req, ts) }
  # p response.headers # Response headers
  raw_body = CGI.unescape(response.raw_body) # Unparsed body
  unless raw_body.empty?
    res, sign = raw_body.split("&")
    JSON.parse res.split("=")[1]
    # else
    #   puts "[error] raw_body is null"
  end
end

# p response.code # Status code
# p response.headers # Response headers
# p response.body # Parsed body
# p JSON.parse res.split("=")[1]

# req = {
#   mobile: "18301775804",
#   password: "qegqIHPUcCReUzcmB3cwOTmBvDvxjEKkGLzPu39vQu1C9ep0l6OuYu4shO0r0j9YxQG7wVwldyPxdPQkTZqwbsAkyvn8sIWf/I8Q619zaXJYAA+mX9bhHH6HJQBW77JB1mWS4nMzmO/x3MIvrUzZubVmwPwdJsngpyplOugayhw=",
#   token: "00000",
#   uuid: "a0b1907c80604f6162058a3c8035b9ef9"
# }
#

def encrypt_password(password)
  password_md5 = Digest::MD5.hexdigest password
  encrypt(password_md5.downcase)
end

# puts encrypt_password("12345678")

# password =  "Hng5nuC67cbjgatfZx12OhF7hyftl2G6/9w/lrvIOxz1ZMV8NpfIoNISj2vLZF6uzD6FkjD28D3n+6QqadL3Y96Li7FUktOSkCYaT6O5A98CMV7GyXNb9TCvRm8oo8BmnTRg86hVM7ZcD56Zvu1BDwypdYi3gQETspj+g7IBLvQ=n"
# puts password
this_sign= ''

# mobile: "18602703057",
# password: password,

post("user/login", {
  mobile: "13057617593",
  password: encrypt_password("12345678"),
  # mobile: "18301775804",
  # password: "qegqIHPUcCReUzcmB3cwOTmBvDvxjEKkGLzPu39vQu1C9ep0l6OuYu4shO0r0j9YxQG7wVwldyPxdPQkTZqwbsAkyvn8sIWf/I8Q619zaXJYAA+mX9bhHH6HJQBW77JB1mWS4nMzmO/x3MIvrUzZubVmwPwdJsngpyplOugayhw=",
  token: "00000",
  uuid: "a0b1907c80604f6162058a3c8035b9ef9"
}).tap do |response|
  puts response
  this_sign = response["data"]
  puts this_sign
end

# puts this_sign

# get("public/send_verify_code", {
#         mobile_phone: "13057617593",
#         code_type: "test"
#       })
#   .tap { |response|
#   puts response
# }
