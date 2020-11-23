require 'stringio'
require 'tempfile'
require 'fileutils'
require_relative '../lib/dinomischus.rb'

# 開発用、本番１用、本番２用　の使い分け設定が可能
# -> キーの復元が出来ないことを利用して。
# 設定の上書きをすることにより、共通設定ができるようにする。

RSpec.describe Dinomischus do
  let(:key_path){ File.join(RSPEC_ROOT, 'resources/forCreate/key.yml') }
  let(:def_path){ File.join(RSPEC_ROOT, 'resources/forCreate/def_file.yml') }
  let(:cfg_path){ File.join(RSPEC_ROOT, 'resources/forCreate/cfg_file.yml') }

  describe '#craetekey 鍵ファイルの作成' do
    after(:each) do
      File.delete(key_path) if File.exists?(key_path)
    end

    context '新規ファイル作成する場合' do
      it 'パスワードの指定無しで作成できること' do
        file = StringIO.new('','w')
        allow(File).to receive(:open).and_yield(file)
        result = Dinomischus::create_key_file(key_path)
        expect( result ).to be true

        yml = YAML.load(file.string)
        expect( yml[:key][:type] ).to eq "sha256"
        expect( yml[:key][:value] ).to match /[a-zA-Z0-9+=\-_]{22}/ 
      end
      it 'パスワードが指定有りで作成できること' do
        file = StringIO.new('','w')
        allow(File).to receive(:open).and_yield(file)
        result = Dinomischus::create_key_file(key_path, 'hogehoge')
        expect( result ).to be true
        yml = YAML.load(file.string)
        expect( yml[:key][:type] ).to eq "sha256"
        expect( yml[:key][:value] ).to match "hogehoge"
      end
    end

    context '既存の鍵ファイルをpathに指定したとき' do

      it '例外が発生すること' do
        FileUtils.touch(key_path)
        expect{ Dinomischus::create_key_file(key_path) }.to raise_error(RuntimeError)
      end
    end
    
    context '引数に問題がある場合' do
      it 'パスの指定がnilの場合' do
        expect{ Dinomischus::create_key_file().with(no_args) }.to raise_error(ArgumentError)
      end
      it 'パスの指定が空文字の場合' do
        expect{ Dinomischus::create_key_file( '' ) }.to raise_error(Errno::ENOENT)
      end
      it '存在しないパスで例外が発生すること' do
        expect{ Dinomischus::create_key_file(key_path + '/NoExists.yml') }.to raise_error(Errno::ENOENT)
      end

    end
  end

  describe '#create_def_file 定義ファイルの作成' do
    before(:each) do
      Dinomischus::create_key_file(key_path)
    end
    after(:each) do
      File.delete(key_path) if File.exists?(key_path)
    end

    xit 'ファイルを作成できる時' do
      file = ::StringIO.new('','w')
      inpt = ::StringIO.new("---\n- :conf_path: ""#{cfg_path}""")
      allow(File).to receive(:open).with(def_path, 'r:bom|utf-8').and_yield(inpt)
      allow(File).to receive(:open).with(def_path, 'w').and_yield(file)
      result = Dinomischus::create_def_file(def_path, 0, cfg_path, key_path)
      p  file.string
    end
    xit 'ファイルを作成できない時' do
      # 'エラーが発生する'
    end
  end
end
