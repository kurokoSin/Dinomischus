require 'openssl'
require 'base64'

module Crypter
  class CryptAes
    # ======================================
    # <暗号化>
    # ======================================
    # plain_text: 暗号化したい文字列
    # password  : 好きなパスワード
    # salt      : ソルト：Base64でエンコードされた文字列
    # ======================================
    def self.encrypt(plain_text, password, use_salt = false)
      raise RuntimeError.new("暗号化対象の文字列がありません。") if plain_text.nil?
      raise RuntimeError.new("暗号化対象の文字列がありません。") if plain_text.empty?
      raise RuntimeError.new("パスワードを設定していません。"  ) if password.nil?
      raise RuntimeError.new("パスワードを設定していません。"  ) if password.empty?
  
      # saltを生成
      # salt = OpenSSL::Random.random_bytes(8)
      salt = use_salt ? OpenSSL::Random.random_bytes(8) : ""
  
      # 暗号器を生成
      enc = OpenSSL::Cipher::AES.new(256, :CBC)
      enc.encrypt
  
      # パスワードとsaltをもとに鍵とivを生成し、設定
      key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 2000, enc.key_len + enc.iv_len, "sha256")
      enc.key = key_iv[0, enc.key_len]
      enc.iv = key_iv[enc.key_len, enc.iv_len]
  
      # 文字列を暗号化
      encrypted_text = enc.update(plain_text) + enc.final
  
      # Base64でエンコード
      encrypted_text = Base64.encode64(encrypted_text).chomp
      salt = Base64.encode64(salt).chomp
  
      # 暗号とsaltを返す
      [encrypted_text, salt]
    end
  
  
    # ======================================
    # <復号>
    # ======================================
    # encrypted_text: 復号したい文字列
    # password      : 暗号化した時に指定した文字列
    # salt          : 暗号化した時に生成されたsalt
    # ======================================
    def self.decrypt(encrypted_text, password, salt_base64 = "") 
      raise RuntimeError.new("復号対象の文字列がありません。") if encrypted_text.nil?
      raise RuntimeError.new("復号対象の文字列がありません。") if encrypted_text.empty?
      raise RuntimeError.new("パスワードがありません。") if password.nil?
      raise RuntimeError.new("パスワードがありません。") if password.empty?
      
  
      # Base64でデコード
      encrypted_text = Base64.decode64(encrypted_text)
      salt = Base64.decode64(salt_base64)  # if !salt_base64.nil? # 空文字でもbase64処理を施す
  
      # 復号器を生成
      dec = OpenSSL::Cipher::AES.new(256, :CBC)
      dec.decrypt
  
      # パスワードとsaltをもとに鍵とivを生成し、設定
      key_iv = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 2000, dec.key_len + dec.iv_len, "sha256")
      dec.key = key_iv[0, dec.key_len]
      dec.iv = key_iv[dec.key_len, dec.iv_len]
  
      # 暗号を復号
      dec.update(encrypted_text) + dec.final
    end
  end
end
