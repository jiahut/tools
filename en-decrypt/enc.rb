require 'openssl'
require 'base64'

PUBLIC_KEY_FILE = 'pub.key'
PRIVATE_KEY_FILE = 'pri.key'

def encrypt(origin_string)
  public_key = OpenSSL::PKey::RSA.new(File.read(PUBLIC_KEY_FILE))
  encrypted_string = Base64.encode64(public_key.public_encrypt(origin_string))
  encrypted_string
end

def decrypt(encrypted_string)
  # private_key = OpenSSL::PKey::RSA.new(File.read(PRIVATE_KEY_FILE),password)
  private_key = OpenSSL::PKey::RSA.new(File.read(PRIVATE_KEY_FILE))
  decrypt_string = private_key.private_decrypt(Base64.decode64(encrypted_string))
  decrypt_string
end

if __FILE__ == $0
  origin_string = 'Hello World!'
  puts "origin_string-----\n #{origin_string}"
  encrypted_string = encrypt(origin_string)
  puts "encrypted_string-----\n #{encrypted_string}"
  decrypted_string = decrypt(encrypted_string)
  puts "decrypt_string------\n #{ decrypted_string }"
end
