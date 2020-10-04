# Dinomischus

This gem is Configuration file utility.
The setting value is encrypted and saved.
You can divide the configuration file into multiple files and save them.

このgemは設定ファイルユーティリティです。
設定値を暗号化して保存します。
設定ファイルを複数に分割して保存できます。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dinomischus'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dinomischus

## Usage

### For Reading
Suppose you have the following configuration file:
```yaml:project_config.yml
---
- :key_path: "/home/vagrant/.crypt_config/project_key.yml"
- :animal:
    :value: |-
      ?0thjXJj2wR4kzp3EidmJ+bgWtYXs7/DZpTlcDFiLjDbsSB2YWnZEB+ovMTNC
      37kx
    :desc: ''
  :fruit:
    :value: |-
      ?wIGrSC/bf5om/rlfIlz7hAIOjaZFjIgw4ulguIKI7YpBrx4JOcmUo3cLH1vC
      eDeW
    :desc: This fruit color is yellow.
```
If you want to use this in the program, you can use it as follows.

```
require 'dinomischus'

# ex1 ( simple reading )
hash = Dinomischus.load_file('config_project.yml')  
# => {:animal=>"owl", 
#     :fruit=>"Lemon"}
p hash[:animal]  # => owl  
p hash[:fruit]   # => Lemon

# ex2 ( more specification )
hash = Dinomischus.load_file('project_config.yml', true)
# => {:animal=>{:value=>"owl", :desc=>""},
#     :fruit=>{:value=>"Lemon", :desc=>"This fruit color is yellow."} }

p hash[:fruit][:value]  # => Lemon
p hash[:fruit][:desc]   # => This fruit color is yellow.
```

Even if there are multiple configuration files, they can be read at once.
In that case, a separate file that defines the reading order is required. (Project_config_index.yml in the example)
If the setting items are duplicated, the setting value of the file read later is given priority. By using this, it is possible to prepare a setting file for the default value and separate the setting file for the development environment and the setting file for the production environment.

```yaml:project_config_index.yml 
---
- :conf_path: "/path/to/config/project_config_default.yml"
- :conf_path: "/path/to/config/project_config_product.yml"
```
```yaml:project_config_default.yml
---
- :key_path: "/home/vagrant/.crypt_config/project_key.yml"
- :animal:
    :value: |-
      ?0thjXJj2wR4kzp3EidmJ+bgWtYXs7/DZpTlcDFiLjDbsSB2YWnZEB+ovMTNC
      37kx
    :desc: ''
  :fruit:
    :value: |-
      ?wIGrSC/bf5om/rlfIlz7hAIOjaZFjIgw4ulguIKI7YpBrx4JOcmUo3cLH1vC
      eDeW
    :desc: This fruit color is yellow.
```
```yaml:project_config_product.yml 
---
- :key_path: "/home/vagrant/.crypt_config/project_key.yml"
- :fruit:
    :value: banana
    :desc: 黄色い果物
  :furniture:
    :value: chair
    :desc:  座る物
```

After reading the above, it will be as follows.

```ruby
require 'dinomischus'
 
hash = Dinomischus.load_file('project_name_config_index.yml')
# => {:animal=>"owl", 
#     :fruit=>"banana",
#     :furniture=>"chair"}
```
The setting value of ```:fruit``` changed to ```banana``` depending on the file read later.

### For Write Setting


#### Create Configure File. First Use
設定ファイル作成(初回設定)

When you execute the following command from terminal.
```
$ cd /path/to/project_root
$ dinomischus
```

A menu will appear.
```
****** Welcome Egoistic Config ******
  1. Make Template
  2. Add or Update Crypted Value
  3. List Configs Simple
  4. List Configs Specify
  c. Clear Screen
  h. Ruby Command List
  z. End 
-----------> Select Menu [1-4,c,h,z]: 
```

Select 1 when the menu appears.

```text
-----------> Select Menu [1-4,c,h,z]: 1
  
****** Make Template ******
  
Input Your Config Prefix Name : ____

```
You will be asked for the first character string for identification of the configuration file. Please enter any characters. (Here prj)
(If there is a file that already exists with the identification character set once, the file creation process is skipped.)

```text
Input Your Config Prefix Name : prj
Make File Default Value is ... 
  Key    File Place [/path/to/home/yourid/.crypt_config/prj_key.yml]
  Config File Place [/path/to/current directory/config/prj_config.yml]
  Define File Place [/path/to/current directory/config/prj_config_index.yml]
 
Press Enter Key to Next Step... 
```
Check the created file and press the enter key.
* Create the ```.crypt_config``` and ```config``` directories if they do not exist.

```text
Done! 
Next Step is Add Crypt Config|Plain Config to /path/to/カレントディレクトリ/config/prj_config.yml .  
Add Config Value then You Select Menu No.2 .
-----------> Select Menu [1-4,c,h,z]: 
```

This completes the template creation.
You can copy the completed file as appropriate, or change the save destination to change the configuration to your liking.
If you change the directory, the path of each file is described at the beginning of the configuration file, so change that as well.

#### Addition of setting encryption value.
Call the menu from the ```dinomischus``` command .

```bash
$ cd /path/to/project_root
$ dinomischus
****** Welcome Egoistic Config ******
  1. Make Template
  2. Add or Update Crypted Value
  3. List Configs Simple
  4. List Configs Specify
  c. Clear Screen
  h. Ruby Command List
  z. End 
-----------> Select Menu [1-4,c,h,z]: 
```
Select 2 when the menu appears.

```text
-----------> Select Menu [1-4,c,h,z]: 2
 
****** Crypted Value Setting ******"
  Input Your Config Path : config/prj_config.yml
  Input Your Key   : email
  Input Your Value : myValue1@example.com
  Input Your Description : Sample e-mail address for settings. It doesn't exist.
 
Done! 
```

After entering the setting file path you want to edit, enter the value you want to set for each item that appears. The encryption of the setting value is over. If all goes well, you should have a configuration file like the one below.

```yaml:config/prj_config_index.yml
---
- :conf_path: "/home/vagrant/config/prj_config.yml"
```
```yaml:config/prj_config.yml
---
- :key_path: "/home/vagrant/.crypt_config/prj_key.yml"
- :dummy:
    :value: ''
    :desc: ''
  :email:
    :value: |-
      ?Afo3Ccn307HZgQgBRwmyUQtCqDus3063wz1h9CIpRMIWdpRC07yfd2TG5jKa
      OrQiDDMfySjQIhWfL1Gt0UJ8tngSiUJT4gfgvjN7/+LHpdk=
    :desc: Sample e-mail address for settings. It doesn't exist.
```
※  If you are concerned about dummy, delete it with a text editor.
   ```{:dummy => {:value: '', :desc:''}}``` 

```yaml:~/.crypt_config/prj_key.yml
---
:key:
  :type: sha256
  :value: eUIZzgKKnsJCoLcRX5pXXg
```

### Description of each file
#### Definition file（```*_config_index.yml```)
Defines the reading order of the configuration files.

* The reading order is from top to bottom.
* If the setting items are duplicated, they will be overwritten with the values read later.
* Two or more files can be defined.

#### Setting file (```*_config.yml```)
The link to the key file (key_path) and the text of the setting value are saved.

* {Setting item => {value: "setting value", desc: "description"}} It is one set in the form of.
* If the first character of the setting value is "?", Attempts to decrypt with the password described in key_path.
* The encrypted setting value is encrypted twice. (The first time is the encrypted character string and salt of the set value, and the second time is the encrypted character string and salt. Combine the ruts into one encrypted string. Due to this effect, even if the setting value is the same, it will be a completely different setting value each time it is encrypted.)
* If you want to set the setting value in plain text, edit it directly using a text editor.

#### Key file（```*_key.yml```）
Stores the password used for encryption / decryption.

* The encryption method is sha256.
* It will be created automatically when the template is created, but ** before encryption ** you can change it to any character string with a text editor. Hmm. (If you change the password after encrypting it, it will fail when decrypting.)
* ```type:``` is a preliminary item for future specification expansion. Currently, "sha256" is an option.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dinomischus. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dinomischus/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dinomischus project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dinomischus/blob/master/CODE_OF_CONDUCT.md).
