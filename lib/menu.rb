#!/usr/bin/env ruby

require 'pp'
require 'fileutils'
require File.expand_path('../dinomischus.rb', __FILE__)

module Dinomischus
  class Menu
    def self.menu()
      loop {
        puts "\e[H\e[2J"      # 画面のクリア
        puts "****** Welcome Egoistic Config ******"
        puts "  1. Make Template"
        puts "  2. Add or Update Crypted Value"
        puts "  3. List Configs Simple"
        puts "  4. List Configs Specify"
        puts "  8. Ruby Command List"
        puts "  9. End "
        print "-----------> Select Menu [1-4,8,9]: "
        sel_num = gets.to_i

        case sel_num
        when 1 then menu_template()
        when 2 then menu_add_config()
        when 3 then list_config(false) # simple
        when 4 then list_config(true)  # specify
        when 8 then command_help()
        when 9 then exit
        end
      }
    end

    def self.menu_template()
      puts "  "
      puts "****** Make Template ******"
      key_path = ""; conf_path = ""; def_path = "";
      loop{
        puts "  "
        print "Input Your Config Prefix Name : "
        prj = gets.chomp
        key_path  = File.expand_path("~/.config/#{prj}_key.yml")
        conf_path = File.expand_path("./config/#{prj}_config.yml", __dir__)
        def_path  = File.expand_path("./config/#{prj}_config_index.yml", __dir__)
        continue if prj == ""
      
        puts "Make File Default Value is ... "
        puts "  Key    File Place [#{key_path}]"
        puts "  Config File Place [#{conf_path}]"
        puts "  Define File Place [#{def_path}]"
        print "Press Any Key to Next Step... "
        ans = gets.chomp
        break 
      }

      make_template(key_path, conf_path, def_path)
      puts " Done! "
      puts " Next Step is Add Crypt Config|Plain Config to #{conf_path}.  "
      puts " Add Config Value by Menu No.2 ."
      puts " Press any key. "
      gets
    end

    def self.menu_add_config()
      puts " "
      puts "****** Make Template ******"
      conf_path = ""
      loop {
        print "  Input Your Config Path : "
        conf_path = gets.chomp
        if !File.exist?(conf_path)
          puts "Error. No Exists Config Path : [#{conf_path}]"
        else
          break
        end
      }
      key = ""; value = ""; desc = "";
      (print "  Input Your Key   : "; key   = gets.chomp ) while key.empty?
      (print "  Input Your Value : "; value = gets.chomp ) while value.empty?
      (print "  Input Your Description : "; desc = gets.chomp ) 

      add_crypted_value(conf_path, key, value, desc)

      puts " Done! "
      puts " Press any key. "
      gets
    end

    def self.list_config(specify = false)
      puts "****** List Configs #{specify ? "Specify" : "Simple"} ******"
      conf_path = ""
      loop {
        print "  Input Your Config Path : "
        conf_path = gets.chomp
        if !File.exist?(conf_path)
          puts "Error. No Exists Config Path : [#{conf_path}]"
        else
          break
        end
      }
      yml = list_config_file( conf_path, specify )
      pp yml
      gets
    end

    # class private method -----------------------------
    
    def self.make_template( key_path, conf_path, def_path)
       check_and_make_dir(key_path)
       check_and_make_dir(def_path)
       check_and_make_dir(conf_path)
       

       Dinomischus.create_key_file(key_path)
       Dinomischus.create_def_file(def_path, conf_path)
       Dinomischus.create_conf_file(conf_path, key_path)
    end

    def self.add_crypted_value(conf_path, key, value, desc)
       Dinomischus.set_config(conf_path, key, value, true, desc)
    end

    def self.list_config_file(path, specify)
      Dinomischus.load_file(path, specify)
    end

    def self.check_and_make_dir(file_path)
      p = File.expand_path('..', file_path )
      FileUtils.mkdir_p( p )   unless Dir.exist?( p )
    end

    def self.command_help()
      puts "
        require 'dinomischus'

        # ex1
        hash = Dinomischus.load('project_name_config_index.yml')  # also project_name_config.yml
        p hash[:key]  # => decrypted-value
        p hash[:key]  # => raw-description

        # ex2
        hash = Dinomischus.load('project_name_config_index.yml', true)  # also project_name_config.yml
        p hash[:key][:value]  # => decrypted-value
        p hash[:key][:desc]   # => raw-description
      "
      gets
    end

    private_class_method :make_template
    private_class_method :add_crypted_value
    private_class_method :list_config_file
    private_class_method :command_help
  end

end

Dinomischus::Menu.menu
