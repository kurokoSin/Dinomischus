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
```
require 'dinomischus'

# ex1
hash = Dinomischus.load('project_name_config_index.yml')  # also project_name_config.yml
p hash[:key]  # => decrypted-value
p hash[:key]  # => raw-description

# ex2
hash = Dinomischus.load('project_name_config_index.yml', true)  # also project_name_config.yml
p hash[:key][:value]  # => decrypted-value
p hash[:key][:desc]   # => raw-description
```

### Create Configure File. First Use
設定ファイル作成(初回設定)

When you execute the following command
```
$ dinomischus
```

A menu will appear.
```
****** Welcome Egoistic Config ******
  1. Make Template
  2. Add or Update Crypted Value
  3. List Configs Simple
  4. List Configs Specify
  8. Ruby Command List
  9. End 
-----------> Select Menu [1-4,8,9]:
```

1 テンプレート作成
2 暗号化設定追加
3 設定ファイルの設定値一覧
4 設定ファイルの設定値一覧（説明付き）
8 プログラム中にファイルを読む際のサンプル
9 プログラム終了


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dinomischus. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dinomischus/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dinomischus project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dinomischus/blob/master/CODE_OF_CONDUCT.md).
