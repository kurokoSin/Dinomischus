require 'yaml'

module Hogehoge
  class FugaFuga
    def self.test(conf_path)
      data = { "fruits" => ["Orange", "Apple", "Grape"] }
      YAML.dump( data, File.open(conf_path + ".t", 'w') )
    end
  end
end

