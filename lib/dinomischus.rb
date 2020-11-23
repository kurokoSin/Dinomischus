require 'yaml'

require_relative "./dinomischus/version"
require_relative "./dinomischus/utils/merge_yaml.rb"
require_relative "./dinomischus/l_key.rb"
require_relative "./dinomischus/l_def.rb"
require_relative "./dinomischus/l_conf.rb"
require_relative "./dinomischus/menu.rb"


module Dinomischus
  class Error < StandardError; end
  
  # Menu
  def self.menu()
    Dinomischus::Menu.menu
  end

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
    # files = yml[0].has_key?(:conf_path) ? yml : [ {conf_path: path} ]
    # base_dir = yml[0].has_key?
    files = []
    base_dir = ""
    if yml[0].has_key?(:conf_path) then
      files = yml
      base_dir = File.dirname(path)
    else
      files = [ {conf_path: path} ]
      base_dir = Dir.pwd
    end

    # loading config files...
    config_list = {}
    files.each do |p|
      items = {}
      conf_path = File.expand_path(p[:conf_path], base_dir )
      items = load_conf(conf_path, specify)
      merge_yaml(config_list, items)
    end
    config_list
  end

private

  def self.load_conf(conf_path, specify )
    Dinomischus::ConfFile.load_file(conf_path, specify)
  end
end

