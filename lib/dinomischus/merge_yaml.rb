# Qiitaの記事からいただきました。
# https://qiita.com/MasahiroMorita@github/items/3679c760fdc7717d84aa
# author: @MasahiroMorita@github

require 'yaml'

def merge_yaml(yaml1, yaml2)
  yaml2.each do |key, value|
    if value.class == Hash && yaml1.key?(key)
      yaml1[key] = merge_yaml(yaml1[key], value)
    else
      yaml1[key] = value
    end
  end
  return yaml1
end
