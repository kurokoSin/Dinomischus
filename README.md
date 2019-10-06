# Dinomischus
Helpful Secure Configuration File Utility

# Not Implemented

# How to Use
Read
Ruby
```
sci = sc.new()
value = sc.read(key)
```

Shell
```
value = `ruby sc.rb /path/to/SecureConfigFile.yml key`
```

```yaml:config_custom.yml
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
  tag: Developase:
  public_key_path: ~/.ssh/id_ed25519.pub
  secret_key_path: ~/.ssh/id_ed25519
  ciphers: ed25519

 
key0_1: 
  value: value0_1
  crypt: true
  help: true = 暗号化、true以外 = 平文
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

key_array:
  value:
    - array_value_01
    - array_value_02
    - array_value_03
  crypt: false
  help: |
    設定サンプル（配列）
    valueにいくつでも入れれる。

key_set:
  value:
    - sub-key1: sub-value01-01
      sub_key2: sub-value01-02
      sub_key3: sub-value01-03
    - sub-key1: sub-value02-01
      sub_key2: sub-value02-02
      sub_key3: sub-value02-03
  crypt: false
  help: |
    設定サンプル。（ハッシュセット）
    sub-key1〜sub-key3　を繰り返しまとめて設定できる。
    (設定内容例） 
    sub-key1 = url
    sub-key2 = name
    sub-key3 = password

key4: 
  value: value4
  crypt: true
  help: カスタマイズ固有設定値(平文)
  tag: Develop

```

```yaml:conig_default.yml

```
