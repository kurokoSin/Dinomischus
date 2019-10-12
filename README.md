# Dinomischus
Helpful Secure Configuration File Utility

# Not Implemented

# 概要メモ（開発中）
このプログラムは設定ファイルを扱うためのライブラリの位置づけです。
これを使って設定したら、設定ファイルにまつわる多くの悩みが解消します。
* 個別に設定値を暗号化することが可能！（パスワードを保存しても安心！）（平文ならテキストエディタで編集もできる！）
* YAMLの設定ファイルをShellから扱うことが可能！（Rubyに限らず色々な場面で使えるね！）
* 設定項目一つ一つにコメント(=help)を記述可能！（運用後でもわかりやすぅ〜い！）
* 設定ファイルから別の設定ファイルへリンクが可能！
  （設定ファイル一つ設定したら全設定呼び出せる！
    本番用、開発用のが楽になる！共通設定、個別設定が分離できる！）


# 使い方メモ（開発中）
## 呼び出し
Ruby
```
# 設定読込
sci = SecureConf.new(yaml_file)
value = sc.read(key)
# 設定追記
sci = SecureConf.new(yaml_file)
sc.add( key, value, crypt_flg, help)
```


シェルから使用する場合
```
# 値読込
value = `ruby sc.rb --read /path/to/SecureConfigFile.yml key`
# 設定追加
ruby sc.rb --add /path/to/SecureConfigFile.yml key value crypt_flg
# テンプレート作成
ruby sc.rb --init /path/to/SecureConfigFile.yml
```

# 設定例
```yaml
# config_custom.yml 
---
base:
  public_key_path: ~/.ssh/id_ecdsa.pub
  secret_key_path: ~/.ssh/id_ecdsa
  ciphers: ecdsa
  default_config_path: ./config_default.yml
 
key1: 
  value: value1-1==
  crypt: true
  help: |
    cryptがtrue の場合、value値は暗号化される。
    (本設定値はサンプルのため復号化できない）
    true = 暗号化、true以外 = 平文

key2: 
  value: value2-1
  crypt: false
  help: |
    設定値サンプル２。
    value2にはstring型が入る

key3: 
  value: value3-1==
  crypt: true
  help: カスタマイズ固有設定値(暗号化)
```

```yaml
# conig_default.yml
---
base:
  public_key_path: ~/.ssh/id_ed25519.pub
  secret_key_path: ~/.ssh/id_ed25519
  ciphers: ed25519

 
key0_1: 
  value: DetarAmEhoGehoGeSD67ncadfe2d==
  crypt: true
  help: |
    cryptがtrue の場合、value値は暗号化される。
    (本設定値はサンプルのため復号化できない）
    true = 暗号化、true以外 = 平文

key0_2: 
  value: value0_2
  crypt: false
  help: 平文デフォルト設定

key1: 
  value: value1==
  crypt: true
  help: true = 暗号化、true以外 = 平文

key2: 
  value: value2
  crypt: false
  help: |
    設定値サンプル２。
    value2にはstring型が入る

key4: 
  value: value4
  crypt: false
  help: デフォルト設定値(平文)
```

configファイルの ```base:default_config_path``` に設定が入っている場合、
そちらを先に読み込んだ後に本ファイルの設定値を上書きで読み込む。
上の例でいくと呼び出し側からはこのような設定に見える。

|設定項目|値(取得する)|値(config_custom)|値(config_default)|
|:-----:|:-------:|:--------------:|:----------------:|
|key0_1 |復号した値|　(無し) | DetarAmEhoGehoGeSD67ncadfe2d== |
|key0_2 | value0_2 | （無し） | value0_2 |
|key1   | [value1-1==]を復号した値 | value1-1== | value1== |
|key2   | value2-1 | value2-1 | value2 |
|key3   | [value3-1==]を復号した値 | value3-1== | （無し） |
|key4   | value4 | (無し） | value4　|
