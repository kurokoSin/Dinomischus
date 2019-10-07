require 'yaml'

# # yaml = YAML.load_file("Assets/config_custom.yml")
# yaml = YAML.load_file("Assets/config_default.yml")
# 
# yaml.class # => Hash
# 
# p yaml["key1"]["value"] # => "value1"
# p yaml["key_array"]["value"] # => "["array_value_01","array_value_02","array_value_03"]"
# p yaml["key_set"]["value"] # =>
# p 
# # yaml.language
# # => NoMethodError: undefined method `language' for #<Hash:0x007fd97d6def08>

class SecureConf
  def initialize(path: )
    @conf = path
    # load
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
