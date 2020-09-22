require 'yaml'
require 'json'
require 'optparse'
require 'securerandom'
require 'base64'

require File.expand_path('../crypt_aes.rb', __FILE__)

module Dinomischus
  class KeyFile
    attr_reader :type, :value

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
      @type  = yml[:key][:type]
      @value = yml[:key][:value]
    end
  end
end

