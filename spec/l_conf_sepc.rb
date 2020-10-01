require 'stringio'
require 'tempfile'
require 'fileutils'
require_relative '../lib/dinomischus/l_conf.rb'

# 開発用、本番１用、本番２用　の使い分け設定が可能
# -> キーの復元が出来ないことを利用して。
# 設定の上書きをすることにより、共通設定ができるようにする。

RSpec.describe Dinomischus do
  let(:key_path){ File.join(__dir__, 'Assets/key.yml') }
  let(:def_path){ File.join(__dir__, 'Assets/def_file.yml') }
  let(:cfg_path){ File.join(__dir__, 'Assets/cfg_file.yml') }
  let(:test_path){ File.join(__dir__,'Assets/sc_default.yml') }

  describe '#ConfFile 設定値追加' do
    context '設定項目を追加する場合' do
      it '平文で追加できること' do
        fcfg = StringIO.new("---\n- :key_path: ""./Assets/key_file.yml""\n- :dummy:\n    :value: ''\n    :desc: ''", 'a+')
        fkey = StringIO.new("---\n:key:\n  :type: sha256\n  :value: mb5XdEjiP3xTUSJdAkktAw", 'r')
        fout = StringIO.new('','a')

        allow(File).to receive(:open).with(cfg_path, 'r:bom|utf-8').and_yield(fcfg).once
        allow(File).to receive(:open).with(key_path, 'r:bom|utf-8').and_yield(fkey).once
        allow(File).to receive(:open).and_yield(fout)
        result = Dinomischus::ConfFile.set_item(cfg_path, 'i_name', 'i_value', 'i_desc', false)
        p fout.string
      end

      it '暗号化されて追加できること' do
        fcfg = StringIO.new("---\n- :key_path: ""./Assets/key_file.yml""\n- :dummy:\n    :value: ''\n    :desc: ''", 'a+')
        fkey = StringIO.new("---\n:key:\n  :type: sha256\n  :value: mb5XdEjiP3xTUSJdAkktAw", "r")
        fout = StringIO.new('','w')

        allow(File).to receive(:open).with(cfg_path, 'r:bom|utf-8').and_yield(fcfg).once
        allow(File).to receive(:open).with(key_path, 'r:bom|utf-8').and_yield(fkey).once
        allow(File).to receive(:open).and_yield(fout)
        result = Dinomischus::ConfFile.set_item(cfg_path, 'i_name', 'i_value', 'i_desc', true)
        p fout.string
        yml = YAML.load(fout.string)
        pending expect( yml[1][:i_name] ).to eq 'i_value'
      end
    end
  end
end
