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
sci = sc.new()
value = sc.read(key)
```

Shell
```
value = `ruby sc.rb --read /path/to/SecureConfigFile.yml key`
```
## 設定方法
暗号化
Ruby
```
sci = sc.new()
sc.add( key, value, crypt_flg, help)
```

shell
```
ruby sc.rb --add /path/to/SecureConfigFile.yml key value crypt_flg
```

## テンプレート作成
Ruby 無し

shell
```
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
  value: value1-1
  crypt: true
  help: true = 暗号化、true以外 = 平文
  tag: Develop,Product

key2: 
  value: value2
  crypt: false
  help: |
    設定値サンプル２。
    value2にはstring型が入る
  tag: Develop

key3: 
  value: value3
  crypt: true
  help: カスタマイズ固有設定値(暗号化)
  tag: Develop
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
  tag: Develop,Product

key0_2: 
  value: value0_2
  crypt: false
  help: 平文デフォルト設定
  tag: Product

key1: 
  value: value1
  crypt: true
  help: true = 暗号化、true以外 = 平文
  tag: Develop,Product

key2: 
  value: value2
  crypt: false
  help: |
    設定値サンプル２。
    value2にはstring型が入る
  tag: Develop

key4: 
  value: value4
  crypt: true
  help: カスタマイズ固有設定値(平文)
  tag: Develop
```

configファイルの ```base:default_config_path``` に設定が入っている場合、
そちらを先に読み込んだ後に本ファイルの設定値を上書きで読み込む。
