require 'yaml'
require 'json'
require 'optparse'
require 'securerandom'
require 'base64'

require File.expand_path('../mods/crypt_aes.rb', __FILE__)

class Dinomischus
  attr_reader :conf, :is_read, :is_update, :is_create
  @confs

  # Create the key file
  def self.create_key_file(path, password = "")
    raise RuntimeError.new("ファイルが存在します。#{path}") if File.exist?(path)
    password = SecureRandom.urlsafe_base64 if password.empty?
    hash = {"key": {"type": "sha256", "value": password}}
    File.open(path, "w") do |f|
      YAML.dump(hash, f)
    end
    true
  end

  def self.create_conf_file(conf_path, key_path)
    raise RuntimeError.new("ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
    raise RuntimeError.new("ファイルが存在します。#{conf_path}") if File.exist?(conf_path)
   
    base = []
    hash = {"key_path": key_path}
    base.push( hash )
    base.push( { "values": "" } )
    File.open(conf_path, "w") do |f|
      YAML.dump(base, f)
    end
  end

  def self.add_config(conf_path, key, value, desc = "", do_encrypt = false)
    raise RuntimeError.new("ファイルが存在しません。#{conf_path}") if !File.exist?(conf_path)
    
    yml = YAML.load_file(conf_path)
    if do_encrypt 
      flg = "encrypt"
      val_text = encrypt( hash[0][:key_path], value)
    else
      flg = "plain"
      val_text = value
    end
    
    yml[1][key] = {"type": flg, "value": val_text, "desc": desc}
    p yml
    File.open(conf_path, "w") do |f|
      YAML.dump( {"type": flg, "value": val_text, "desc": desc}, f )
    end
    # YAML.dump( yml, File.open(conf_path + ".t", 'w') )
    # YAML.dump( {"type": flg, "value": val_text, "desc": desc}, File.open(conf_path + ".t", 'w') )
    # yml.push({"#{key}": {:type: flg, :value: val_text, :desc: desc}})
  end

  def self.test(conf_path)
    data = { "fruits" => ["Orange", "Apple", "Grape"] }
    YAML.dump( data, File.open(conf_path + ".t", 'w') )
  end


  # Create the define file
  def self.create_def_file(def_path, pos, conf_path, key_path)
    raise RuntimeError.new("定義ファイルの指定がありません。#{def_path}"  ) if blank?(def_path)
    raise RuntimeError.new("挿入位置を整数で指定してください。#{pos}"     ) if pos.to_s =~ !/\A[0-9]+\z/
    raise RuntimeError.new("設定ファイルの指定がありません。#{conf_path}" ) if blank?(conf_path)
    raise RuntimeError.new("鍵ファイルの指定がありません。#{key_path}"    ) if blank?(key_path)  || !File.exist?(key_path)

    if File.exist?(def_path)
      def_file = YAML.load_file(def_file)
      p def_file
    else
      def_hash = {"conf_path": conf_path}
      dat = [ def_hash ]
      File.open(def_path, "w") do |f|
        f.puts YAML.dump(dat)
      end
    end
  end

  def self.load(def_path)
    def_file = YAML.load_file(def_path)
    def_file.each do |p|
      load_conf(p[:conf_path])
    end
    
  end

  def self.load_conf(conf_path)
    conf_file = YAML.load_file(conf_path)
    key_file = YAML.load_file(conf_file[0][:key_path])
    @conf_item = []
    conf_file.each do |k|
      continue if k.key == key_path
      keyval = parse_value(k)
      @conf_item.add(keyval)
    end
  end

  def self.parse_value(kv)
  end


  def initialize(path, *args)
    args = %w[--read-only] if args.empty?

    opt = OptionParser.new
    # opt.on('--write'    ) { |v| :is_read = v, :is_update = v,  :is_create = v}
    # opt.on('--read-only') { |v| :is_read = v, :is_update = !v, :is_create = !v}

    raise ArgumentError.new(
            "wrong number of arguments (given #{args.size+1}, 
             Usage: path [--read-only | --write | --overwrite]
            )"
    ) unless args.size == 2
    
    @conf = path 
    load
  end

  
  def save
    base = {:base => {:crypt_type => @crypt_type, 
                     :crypt_public_key => @crypt_public_key,
                     :crypt_private_key => @crypt_private_key
                    }
           }
    FileUtils.touch(@conf) if File.exist?(@conf)
    File.open(@conf, "w") do |f|
      f.puts( base.to_json )
    end
    puts base.to_json
  end

  def get(key)
      @yaml[key]["value"]
  end

  def put(key, value, crypted, help)
    self.save

    kv = {key => {:value => value, :crypted => crypted, :help => help }}
    @yaml.merge(kv)
    YAML.dump(@yaml, File.open(@conf, 'w'))
  end

  def update(key, value, crypted )

  end

  def delete(key)
  end

private
  def self.blank?(obj)
    obj.nil? || obj.empty?
  end

  def self.encrypt( key_path, value)
    raise RuntimeError.new("ファイルが存在しません。#{key_path}") if !File.exist?(key_path)
    
    keys = YAML.load(key_path)
    p keys
    pass = keys[:value]
    enc1 = Crypter::CryptAES.crypt( value, pass )
    p "enc1: #{enc1}"
    enc2 = Crypter::CryptAES.crypt( enc1, pass, Base64.encode64(pass).chomp )
    p "enc2: #{enc2}"
    enc2[0]
  end

end

