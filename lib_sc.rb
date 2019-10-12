require 'yaml'

class SecureConf
  attr_reader :conf, :crypt_type, :crypt_public_key, :crypt_private_key
  def initialize( path, *args)
    args = %w[ed25519 ~/.ssh/id_ed25519.pub ~/.ssh/id_ed25519] if args.empty?
    raise ArgumentError.new("wrong number of arguments (given #{args.size+1}, expected 1 or 4)") unless args.size == 3
    @crypt_type, @crypt_public_key, @crypt_private_key = args
    @conf = path 
    load
  end

  def load
    @yaml = YAML.load_file(@conf)
  end

  def path_change(path: )
    @conf = path
    load
  end

  def get(key)
      @yaml[key]["value"]
  end

  def put(key, value, crypted, help)
  end

  def update(key, value, crypted )

  end

  def delete(key)
  end

end

