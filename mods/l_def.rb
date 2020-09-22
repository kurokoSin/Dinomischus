require 'yaml'
require 'json'
require 'optparse'
require 'securerandom'
require 'base64'

require File.expand_path('../mods/crypt_aes.rb', __FILE__)

module Dinomischus
  attr_reader :items
  class DefFile
    # Create the define file
    def self.create(def_path, conf_path )
      raise RuntimeError.new("定義ファイルの指定がありません。#{def_path}"  ) if blank?(def_path)
      raise RuntimeError.new("定義ファイルが既に存在します。#{def_path}"    ) if File.exist?(def_path)
      raise RuntimeError.new("挿入位置を整数で指定してください。#{pos}"     ) if pos.to_s =~ !/\A[0-9]+\z/
      raise RuntimeError.new("設定ファイルの指定がありません。#{conf_path}" ) if blank?(conf_path)
      raise RuntimeError.new("鍵ファイルの指定がありません。#{key_path}"    ) if blank?(key_path) 
      raise RuntimeError.new("鍵ファイルが存在しません。#{key_path}"        ) if !File.exist?(key_path)

       def_hash = {"conf_path": conf_path}
       File.open(def_path, 'w') do |f|
         YAML.dump(daf_hash, f)
       end
       true
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

