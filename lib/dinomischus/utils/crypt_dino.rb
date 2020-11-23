require 'base64'
require 'securerandom'
require_relative './crypt_aes.rb'

module Dinomischus
  def self.dino_encrypt(key_path, value)
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
      
      keys = YAML.load_file(key_path)
      enctype = keys[:key][:type] 
      if enctype == "sha256"
        # sha256の処理。
        pass = keys[:key][:value]
        enc1 = Crypter::CryptAes.encrypt( value, pass, true )
        enc2 = Crypter::CryptAes.encrypt( enc1.to_s, pass, false )
      else
        raise RuntimeError.new("未サポートの暗号です。#{enctype}")
      end
      enc2[0]
  end

  def self.dino_decrypt(key_path, value)
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
      
      keys = YAML.load_file(key_path)
      enctype = keys[:key][:type] 
      if enctype == "sha256"
        pass = keys[:key][:value]
        v2 = Crypter::CryptAes.decrypt( value, pass )
        v1raw = YAML.load(v2)
        v1 = Crypter::CryptAes.decrypt( v1raw[0], pass, v1raw[1])
      else
        raise RuntimeError.new("未サポートの暗号です。#{enctype}")
      end
  end
end

