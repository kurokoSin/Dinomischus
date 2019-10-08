require 'yaml'

class CryptInfo
  def initialize(crypt_type: 'ed25519', public_key: '~/.ssh/id_ed25519.pub', private_key: '~/.ssh/id_ed25519' )
    @crypt_type = crypt_type
    @public_key = public_key
    @private_key = private_key
  end

  attr_accessor: :crypt_type
  attr_accessor: :public_key
  attr_accessor: :private_key
end

class SecureConf
  def initialize( path, crypt_type: 'ed25519', public_key: '~/.ssh/id_ed25519.pub', private_key: '~/.ssh/id_ed25519' )
    @conf = path
    @cryptype = cp.crypt_type
    @public_key = cp.public_key
    @private_key = cp.private_key
  end


  def load
    @yaml = YAML.load(@conf)
  end

  def path_change(path: )
    @conf = path
    load
  end

  def get(key)
    if yaml[key]["crypt"] = true then
      decrypt(yaml[key]["value"]) 
    else
      # If plane text
      yaml[key]["value"]
    end
  end

  def add(key, value, crypted, help)
  end

  def update(key, value, crypted )

  end

  def remove(key)
  end

end

