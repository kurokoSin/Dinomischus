require 'yaml'

require File.expand_path('../mods/crypt_aes.rb', __FILE__)
require File.expand_path('../mods/merge_yaml.rb', __FILE__)
require File.expand_path('../mods/l_key.rb', __FILE__)
require File.expand_path('../mods/l_def.rb', __FILE__)
require File.expand_path('../mods/l_conf.rb', __FILE__)

module Dinomischus

  # Create the key file
  def self.create_key_file(path, password = "")
    Dinomischus::KeyFile.create(path, password)
  end

  # Create the define file
  def self.create_def_file(def_path, conf_path)
    Dinomischus::DefFile.create(def_path, conf_path)
  end

  def self.create_conf_file(conf_path, key_path)
    Dinomischus::ConfFile.create(conf_path, key_path)
  end

  def self.set_config(conf_path, key, value, desc = "", do_encrypt = false)
    Dinomischus::ConfFile.set_item(conf_path, key, value, desc, do_encrypt)
  end

  # Read Config File
  def self.load_file( path, specify = false )
    # get loading target
    yml = YAML.load_file(path)
    files = yml[0].has_key?(:conf_path) ? yml : [ {conf_path: path} ]

    # loading config files...
    config_list = {}
    files.each do |p|
      items = {}
      items = load_conf(p[:conf_path], specify)
      merge_yaml(config_list, items)
    end
    config_list
  end

private

  def self.load_conf(conf_path, specify )
    Dinomischus::ConfFile.load_file(conf_path, specify)
  end
end

