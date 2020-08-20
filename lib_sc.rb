require 'yaml'
require 'json'
require 'optparse'
require 'securerandom'

require File.expand_path('../mods/crypt_aes.rb', __FILE__)

class Dinomischus
  attr_reader :conf, :is_read, :is_update, :is_create

  # Create the key file
  def self.createkey?(path, *args)
    return false if File.exist?(path)
    pass = SecureRandom.urlsafe_base64 if args.empty?
    hash = {"key": {"type": "sha256", "value": pass}}
    File.open(path, "w") do |f|
      f.puts( YAML.dump(hash) )
    end
    true
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

  def load
    @yaml = YAML.load_file(@conf)
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

  def path_change(path: )
    @conf = path
    load
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

end

