require 'yaml'
require 'json'
require 'optparse'
require 'securerandom'
require 'base64'

require File.expand_path('../crypt_aes.rb', __FILE__)
require File.expand_path('../l_conf.rb', __FILE__)

module Dinomischus
  attr_reader :items
  class DefFile
    # Create the define file
    def self.create(def_path, conf_path )
      raise RuntimeError.new("定義ファイルの指定がありません。#{def_path}"  ) if blank?(def_path)
      raise RuntimeError.new("定義ファイルが既に存在します。#{def_path}"    ) if File.exist?(def_path)
      raise RuntimeError.new("設定ファイルの指定がありません。#{conf_path}" ) if blank?(conf_path)
      raise RuntimeError.new("設定ファイルが既に存在します。#{conf_path}"   ) if File.exist?(conf_path)

       def_hash = {"conf_path": conf_path}
       File.open(def_path, 'w') do |f|
         YAML.dump(daf_hash, f)
       end
       true
    end

    # Load All Config
    def self.load_config(def_path)
      files = load_file(def_path)
      configs = {}
      files.each do |f|
        cfg = Dinomischus::ConfFile.load_file(f[:conf_path])
        configs.merge!(cfg)
      end
      configs
    end

    #
    def self.load_file(def_path)
      yml = YAML.load_file(def_path)
    end

  end

private
  def self.blank?(obj)
    obj.nil? || obj.empty?
  end
end

