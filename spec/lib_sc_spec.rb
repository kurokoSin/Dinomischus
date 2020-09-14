require 'stringio'
require 'tempfile'
require 'fileutils'
require_relative '../lib_sc.rb'

# 開発用、本番１用、本番２用　の使い分け設定が可能
# -> キーの復元が出来ないことを利用して。
# 設定の上書きをすることにより、共通設定ができるようにする。

RSpec.describe Dinomischus do
  let(:key_path){ File.join(__dir__, 'Assets/key.yml') }
  let(:def_path){ File.join(__dir__, 'Assets/def_file.yml') }
  let(:cfg_path){ File.join(__dir__, 'Assets/cfg_file.yml') }
  let(:test_path){ File.join(__dir__,'Assets/sc_default.yml') }
#  let(:sc1){ SecureConf.new( test_path ) }
#  let(:sc4){ SecureConf.new( test_path, params[0], params[1], params[2]) }

  describe '#craetekey 鍵ファイルの作成' do
    after(:each) do
      File.delete(key_path) if File.exists?(key_path)
    end

    context '新規ファイル作成する場合' do
      it 'パスワードの指定無しで作成できること' do
        file = StringIO.new('','w')
        allow(File).to receive(:open).and_yield(file)
        result = Dinomischus::create_key_file(key_path)
        p file.string
        expect( result ).to be true
      end
      it 'パスワードが指定有りで作成できること' do
        result = Dinomischus::create_key_file(key_path, 'hogehoge')
        expect( result ).to be true
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

    it 'ファイルを作成できる時' do
      file = ::StringIO.new('','w')
      allow(File).to receive(:open).and_yield(file)
      # allow(File).to receive(:open).and_return(file)
#      result = Dinomischus.test(def_path)
      result = Dinomischus::create_def_file(def_path, 0, cfg_path, key_path)
      p  file.string
#      skip expect( File.exists?(def_path) ).to be true
    end
    it 'ファイルを作成できない時' do
      pending 'エラーが発生する'
    end
  end
#  describe '#initialize コンストラクタ' do
#    context '引数が ０ or ２つ or ３つ のとき' do
#      it 'エラーになること' do
#        expect{ SecureConf.new() }.to raise_error( ArgumentError )
#        expect{ SecureConf.new(:hogehoge, :fugafuga) }.to raise_error( ArgumentError )
#        expect{ SecureConf.new(:hogehoge, :fugafuga, :halahala) }.to raise_error( ArgumentError )
#      end
#    end
#
#    context '引数が一つのとき' do
#      it 'インスタンスが作成されること' do
#        expect( sc1.nil? ).to be_falsey
#      end
#      it 'デフォルト値が取得できること' do
#        expect( sc1.conf ).to eq test_path
#        expect( sc1.crypt_type ).to eq "ed25519"
#        expect( sc1.crypt_public_key ).to eq "~/.ssh/id_ed25519.pub"
#        expect( sc1.crypt_private_key ).to eq "~/.ssh/id_ed25519"
#      end
#    end
#    
#    let(:params){ %w[rsa ~/.ssh/id_rsa.pub ~/.ssh/id_rsa] }
#    context '引数が４つのとき' do
#      it 'インスタンスが生成されること' do
#        expect( sc4.nil? ).to be_falsey
#      end
#      it '値が設定されていること' do
#        expect( sc4.conf ).to eq test_path
#        expect( sc4.crypt_type ).to eq "rsa"
#        expect( sc4.crypt_public_key).to eq "~/.ssh/id_rsa.pub"
#        expect( sc4.crypt_private_key).to eq "~/.ssh/id_rsa"
#      end
#    end
#   
#  end

#  describe 'Ruby から利用する。' do
#    let(:temp_out_path){ File.join(__dir__,'Assets/temp.yml') }
#    context '#get 値を読み込むとき、' do
#      it '平文の読込ができること' do
#        expect(sc1.get("key_")).to eq "value_"
#      end
#      it '暗号化された値の読込ができること' do
#        expect(sc1.get("key1")).to eq "value1"
#      end
#    end
#    context '#save ファイル保存するとき' do
#      it '新規で保存すること' do
#        Tempfile.create(temp_out_path) do |f|
#          sc = SecureConf.new(f.path)
#          sc.save
#        end
#      end
#    end
#    context '#put 値を書き込むとき、' do
#      it '平文で保存すること' do
#        Tempfile.create(temp_out_path) do |f|
#          sc = SecureConf.new(f.path)
#          sc.put(key, value) 
#          ryml = YAML.load_file(f.path)
#          expect( ryml["key"]["value"] ).to eq 'value'
#          # expect( ryml["key"]["crypted"] ).to eq 'False'
#          # expect( ryml["key"]["help"] ).to eq ''
# 
#          # sc.put(key, value, nil) 
#          sc.put(key, value, False) 
#          # sc.put(key, value, False, :HelpTextMessage)
#          sc.load()
#          expect( sc.get("key") ).to eq "value"
#        end
#      end
#      it '暗号化して保存すること' do
#        Tempfile.create(temp_out_path) do |f|
#          sc = SecureConf.new(f.path)
#          expect( sc.put(:enckey, :encfugafuga, True) ).to eq ''
#          expect( sc.put(key, value, True)   ).to eq ''
#          expect( sc.put(key, value, True, :HelpTextMessage) ).to eq ''
#        end
#      end
#      
#      GC.enable
#    end
#  end

  describe 'シェルで使用する' do
    context '#init 設定ファイル作成するとき、' do
    end
    context '#read 値を読み込むとき、' do
    end
    context '#get 値を読み込むとき、' do
      it '平文の読込ができること' do
#        expect( system('sc -r key_') ).to eq "value_"
      end
      it '暗号化された値の読込ができること' do
#        expect( system('sc -r key1') ).to eq "value1"
      end
    end
    context '#help ヘルプメッセージ' do
    end
    context '#list キーワードリスト' do
    end
  end

end
