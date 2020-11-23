require 'yaml'
require 'json'
require 'optparse'
require 'securerandom'
require 'base64'

module Dinomischus
  class KeyFile

    # Create the key file
    def self.create(path, password = "")
      raise RuntimeError.new("鍵ファイルが既に存在します。#{path}") if File.exist?(path)
      password = SecureRandom.urlsafe_base64 if password.empty?
      hash = {"key": {"type": "sha256", "value": password}}
      File.open(path, 'w') do |f|
        YAML.dump(hash, f)
      end
      true
    end

    def self.load_file(path)
      yml = YAML.load_file(path)
    end
  end
end

