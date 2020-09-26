#!/usr/bin/env ruby

module Dinomischus
  class Menu
    def self.menu()
      loop {
        puts "\e[H\e[2J"      # 画面のクリア
        puts "****** Welcome Egoistic Config ******"
        puts "1. Make Template"
        puts "2. Add or Update Crypted Value"
        puts "3. List Configs Simple"
        puts "4. List Configs Specify"
        puts "8. Ruby Command List"
        puts "9. End "
        puts "-----------> Select Menu [1-4,8,9]: "
        sel_num = gets.to_i

        case sel_num
        when 1 then menu_template()
        when 2 then menu_add_config()
        when 3 then list_simple()
        when 4 then list_specify()
        when 8 then command_help()
        when 9 then exit
        end
      }
    end

    def self.menu_template()
      puts "****** Make Template ******"
      loop{
        puts "  "
        puts "  Input Your Config Prefix Name : "
        prj = gets
        key_path  = File.expand_path("~/.config/#{prj}_key.yml")
        conf_path = File.expand_path("./config/#{prj}_config.yml", __dir__)
        def_path  = File.expand_path("./config/#{prj}_config_index.yml", __dir__)
        puts "Make File Default Value is ... "
        puts "  Key File Place [#{key_path}]"
        puts "  Config File Place [#{conf_path}]"
        puts "  Define File Place [#{def_path}]"
        puts "It's OK ? y or n [Y] "
        ans = gets
        break if ans == "y" || ans == "Y" || ans == "yes" || ans == ""
      }

      make_template(key_path, conf_path, def_path)
      puts " Done! "
      puts " Next Step is Add Crypt Config|Plain Config to #{conf_path}.  "
      puts " Add Config Value by Menu."
      puts " Press any key. "
      gets
    end

    def self.make_template( key_path, conf_path, def_path)
       Dinomischus::KeyFile.create(key_path)
       Dinomischus::DefFile.create(def_path, conf_path)
       Dinomischus::ConfFile.create(conf_path, key_path)
    end

    def self.menu_add_config(conf_path = "")
      puts "****** Make Template ******"
      loop {
        puts "  Input Your Config Path : "
        conf_path = gets
        if !File.exist(conf_path)
          puts "Error. No Exists Config Path : [#{conf_path}]"
        else
          break
        end
      }
      puts "  Input Your Key : "
      key = gets
      puts "  Input Your Value : "
      value = gets
      puts "  Input Your Description : "
      desc = gets

      add_crypted_value(conf_path, key, value, desc)

      puts " Done! "
      puts " Press any key. "
    end

    def self.add_crypted_value(conf_path, key, value, desc)
       Dinomischus::ConfFile.add(conf_path, key, value, true, desc)
    end

    def self.menu_ruby_command_list()
      puts '
        require ''dinomischus''
        hash = Dinomischus::load(''project_name_config_index.yml'')  # also project_name_config.yml
        p hash[:key][:value]  # => raw-value
        p hash[:key][:desc]   # => raw-description
      '
    end
  end

end

