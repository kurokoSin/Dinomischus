require 'yaml'
require 'json'
require 'optparse'
require 'securerandom'
require 'base64'

require File.expand_path('../crypt_aes.rb', __FILE__)

module Dinomischus

  class ConfFile
    # create config file
    def self.create(conf_path, key_path)
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
      raise RuntimeError.new("設定ファイルが既に存在します。#{conf_path}") if File.exist?(conf_path)
   
      base = []
      hash = {"key_path": key_path}
      base.push( hash )
      base.push( {"dummy": { "value": "", "desc": "" }} )
      File.open(conf_path, 'w') do |f|
        YAML.dump(base, f)
      end
    end


    def self.add(conf_path, key, value, desc = "", do_encrypt = false)
      raise RuntimeError.new("設定ファイルが存在しません。#{conf_path}") if !File.exist?(conf_path)
      
      yml = YAML.load_file(conf_path)
  
      key_path = yml[0][:key_path]
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
      
      if do_encrypt 
        val_text = "?#{exec_encrypt( key_path, value)}"
      else
        val_text = value
      end
      
      yml[1][key] = {"value": val_text, "desc": desc}
      p yml
      File.open(conf_path, 'w') do |f|
        YAML.dump( yml, f )
      end
      true
    end
  
  
    def self.load_file(conf_path)
      conf_file = YAML.load_file(conf_path)
      @key_path = conf_file[0][:key_path]
      items = {}
      conf_file.each do |hash|
        continue if k.key == key_path
        keyval = get(hash, hash.key, key_path)
        keydesc = hash[key][:desc]
        items[key] = {"value": keyval, "desc": keydesc}
      end
      items
    end
  
  
    def self.get(hash, key, key_path)
      ret = hash[key]["value"]
      ret = exec_decrypt(key_path, ret) if ret.match /^\?.*/
    end

    def self.get_test(value, key_path)
      exec_decrypt(key_path, value)
    end
  
    def put(key, value, crypted, desc)
      new_value = !crypted ? value : exec_encrypt( value, key_path)
  
      kv = {key: {"value": value, "crypted": crypted, "desc": desc }}
      @yaml.merge(kv)
      File.open(conf_path, 'w' ) do |f|
        YAML.dump(kv, f)
      end
    end
  
  private
    def self.blank?(obj)
      obj.nil? || obj.empty?
    end
  
    def self.exec_encrypt( key_path, value)
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
      
      keys = YAML.load_file(key_path)
      enctype = keys[:key][:type] 
      if enctype == "sha256"
        # sha256の処理。
        pass = keys[:key][:value]
        enc1 = Crypter::CryptAes.encrypt( value, pass, true )
        p "enc1_s => #{enc1.to_s}"
        enc2 = Crypter::CryptAes.encrypt( enc1.to_s, pass, false )
      else
        raise RuntimeError.new("未サポートの暗号です。#{enctype}")
      end
      enc2[0]
    end
  
    def self.exec_decrypt( key_path, value)
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
      
      keys = YAML.load_file(key_path)
      p keys
      enctype = keys[:key][:type] 
      if enctype == "sha256"
        pass = keys[:key][:value]
        p pass
        v2 = Crypter::CryptAes.decrypt( value, pass )
        p "v2: #{v2}"
        v1raw = YAML.load(v2)
        v1 = Crypter::CryptAes.decrypt( v1raw[0], pass, v1raw[1])
        p "v1: #{v1}"
        v1
      else
        raise RuntimeError.new("未サポートの暗号です。#{enctype}")
      end
    end

  end
end

