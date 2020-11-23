require 'stringio'
require 'tempfile'
require 'fileutils'
require_relative '../lib/dinomischus/l_conf.rb'

# 開発用、本番１用、本番２用　の使い分け設定が可能
# -> キーの復元が出来ないことを利用して。
# 設定の上書きをすることにより、共通設定ができるようにする。

RSpec.describe Dinomischus do
  let(:test_path){ File.join(RSPEC_ROOT,'resources/forWrite/config_base.yml') }

  describe '#ConfFile 設定値追加' do
    xcontext '設定項目を追加する場合' do
      it '平文で追加できること' do
        result = Dinomischus::ConfFile.set_item(cfg_path, 'i_name', 'i_value', 'i_desc', false)
      end

      it '暗号化されて追加できること' do
        fout = StringIO.new('','w')
        allow(File).to receive(:open).and_yield(fout)
       
        result = Dinomischus::ConfFile.set_item(cfg_path, 'i_name', 'i_value', 'i_desc', true)
        p fout.string
        yml = YAML.load(fout.string)
        expect( yml[1][:i_name] ).to eq 'i_value'
      end
    end
  end

  describe '#ConfFile 設定値読込' do
    context '設定ファイルの読込(相対パス指定)' do
      let(:cfg_path){ File.join(RSPEC_ROOT, 'resources/config/config_base.yml') }

      it '平文の読込' do
        result = Dinomischus.load_file(cfg_path)
        expect( result[:userId] ).to eq "sampleUserId"
      end

      it '暗号値の読込' do
        result = Dinomischus.load_file(cfg_path)
        expect( result[:password] ).to eq 'samplePassword'
      end
    end

    context '定義ファイルの読込' do
      let(:def_path){ File.join(RSPEC_ROOT, 'resources/config/index.yml') }

      context '平文の読込' do
        it 'overwriteの指定が無い設定はbaseの設定であること' do
          result = Dinomischus.load_file(def_path)
          expect( result[:userId] ).to eq "sampleUserId"   
        end
        it 'overwrite の設定値であること' do
          result = Dinomischus.load_file(def_path)
          expect( result[:userName] ).to eq "overwriteName"   
        end
      end

      context '暗号文の読込' do
        it 'base のままであること' do
          result = Dinomischus.load_file(def_path)
          expect( result[:password] ).to eq "samplePassword"   
        end
        it 'overwrite の設定値であること' do
          result = Dinomischus.load_file(def_path)
          expect( result[:"e-mail"] ).to eq "jhon.do@example.com"   
        end
      end
    end
  end
end
