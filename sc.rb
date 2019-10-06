require 'yaml'

# yaml = YAML.load_file("Assets/config_custom.yml")
yaml = YAML.load_file("Assets/config_default.yml")

yaml.class # => Hash

p yaml["key1"]["value"] # => "value1"
p yaml["key_array"]["value"] # => "["array_value_01","array_value_02","array_value_03"]"
p yaml["key_set"]["value"] # =>
p 
# yaml.language
# => NoMethodError: undefined method `language' for #<Hash:0x007fd97d6def08>

class SecureConf
  @conf = "Assets/config_default.yml"

  def self.read
    @yaml = YAML.load(@conf)
  end

  def self.get(key)
    if yaml[key]["crypt"] = true then
      decrypt(yaml[key]["value"]) 
    else
      # If plane text
      yaml[key]["value"]
    end
  end

  def self.add(key, value, crypted, help)
  end

  def self.update(key, value, crypted )

  end

  def self.remove(key)
  end

end
