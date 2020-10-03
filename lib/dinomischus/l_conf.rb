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


    def self.set_item(conf_path, key, value, desc = "", do_encrypt = false)
      raise RuntimeError.new("設定ファイルが存在しません。#{conf_path}") if !File.exist?(conf_path)
      
      yml = YAML.load_file(conf_path)
  
      key_path = yml[0][:key_path]
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
      
      val_text = do_encrypt ? "?#{exec_encrypt( key_path, value)}" : value
      
      yml[1][key.to_sym] = {"value": val_text, "desc": desc}
      File.open(conf_path, 'w') do |f|
        YAML.dump( yml, f )
      end
      true
    end
  
  
    def self.load_file(conf_path, specify = false )
      raise RuntimeError.new("設定ファイルが存在しません。#{conf_path}") if !File.exist?(conf_path)

      conf_file = YAML.load_file(conf_path)
      key_path = conf_file[0][:key_path]
      raw_items = conf_file[1]
      items = {}
      raw_items.keys.each do |key|
        continue if key == "dummy" && raw_items[key][:value] == ""
        keyval = get(key_path, raw_items[key][:value] )
        keydesc = raw_items[key][:desc]
        items[key] = specify ? {"value": keyval, "desc": keydesc} : keyval
      end
      items
    end
  
  
    # private class method -----------------

    def self.blank?(obj)
      obj.nil? || obj.empty?
    end
  
    def self.get(key_path, value)
      ret = value
      if value.match /^\?.*/
        ret.gsub!("\n","")
        ret = ret[/\?(.*)/, 1]
        ret = exec_decrypt(key_path, ret) 
      else
        ret = value
      end

      ret
    end

    def self.exec_encrypt( key_path, value)
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
  
    def self.exec_decrypt( key_path, value)
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

    private_class_method :blank?
    private_class_method :get
    private_class_method :exec_encrypt
    private_class_method :exec_decrypt
    
  end
end

