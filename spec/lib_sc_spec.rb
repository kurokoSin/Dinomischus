require 'stringio'
require 'tempfile'
require_relative '../lib_sc.rb'


RSpec.describe SecureConf do
  let(:test_path){ File.join(__dir__,'Assets/sc_default.yml') }
  let(:sc1){ SecureConf.new( test_path ) }
  let(:sc4){ SecureConf.new( test_path, params[0], params[1], params[2]) }

  describe '#initialize コンストラクタ' do
    context '引数が ０ or ２つ or ３つ のとき' do
      it 'エラーになること' do
        expect{ SecureConf.new() }.to raise_error( ArgumentError )
        expect{ SecureConf.new(:hogehoge, :fugafuga) }.to raise_error( ArgumentError )
        expect{ SecureConf.new(:hogehoge, :fugafuga, :halahala) }.to raise_error( ArgumentError )
      end
    end

    context '引数が一つのとき' do
      it 'インスタンスが作成されること' do
        expect( sc1.nil? ).to be_falsey
      end
      it 'デフォルト値が取得できること' do
        expect( sc1.conf ).to eq test_path
        expect( sc1.crypt_type ).to eq "ed25519"
        expect( sc1.crypt_public_key ).to eq "~/.ssh/id_ed25519.pub"
        expect( sc1.crypt_private_key ).to eq "~/.ssh/id_ed25519"
      end
    end
    
    let(:params){ %w[rsa ~/.ssh/id_rsa.pub ~/.ssh/id_rsa] }
    context '引数が４つのとき' do
      it 'インスタンスが生成されること' do
        expect( sc4.nil? ).to be_falsey
      end
      it '値が設定されていること' do
        expect( sc4.conf ).to eq test_path
        expect( sc4.crypt_type ).to eq "rsa"
        expect( sc4.crypt_public_key).to eq "~/.ssh/id_rsa.pub"
        expect( sc4.crypt_private_key).to eq "~/.ssh/id_rsa"
      end
    end
   
  end

  describe 'Ruby から利用する。' do
    let(:temp_out_path){ File.join(__dir__,'Assets/temp.yml') }
    context '#get 値を読み込むとき、' do
      it '平文の読込ができること' do
        expect(sc1.get("key_")).to eq "value_"
      end
      it '暗号化された値の読込ができること' do
        expect(sc1.get("key1")).to eq "value1"
      end
    end
    context '#save ファイル保存するとき' do
      it '新規で保存すること' do
        Tempfile.create(temp_out_path) do |f|
          sc = SecureConf.new(f.path)
          sc.save
        end
      end
    end
    context '#put 値を書き込むとき、' do
      it '平文で保存すること' do
        Tempfile.create(temp_out_path) do |f|
          sc = SecureConf.new(f.path)
          sc.put(key, value) 
          ryml = YAML.load_file(f.path)
          expect( ryml["key"]["value"] ).to eq 'value'
          # expect( ryml["key"]["crypted"] ).to eq 'False'
          # expect( ryml["key"]["help"] ).to eq ''
 
          # sc.put(key, value, nil) 
          sc.put(key, value, False) 
          # sc.put(key, value, False, :HelpTextMessage)
          sc.load()
          expect( sc.get("key") ).to eq "value"
        end
      end
      it '暗号化して保存すること' do
        Tempfile.create(temp_out_path) do |f|
          sc = SecureConf.new(f.path)
          expect( sc.put(:enckey, :encfugafuga, True) ).to eq ''
          expect( sc.put(key, value, True)   ).to eq ''
          expect( sc.put(key, value, True, :HelpTextMessage) ).to eq ''
        end
      end
      
      GC.enable
    end
  end

  describe 'シェルで使用する' do
    context '#init 設定ファイル作成するとき、' do
    end
    context '#read 値を読み込むとき、' do
    end
    context '#get 値を読み込むとき、' do
      it '平文の読込ができること' do
        expect( system('sc -r key_') ).to eq "value_"
      end
      it '暗号化された値の読込ができること' do
        expect( system('sc -r key1') ).to eq "value1"
      end
    end
    context '#help ヘルプメッセージ' do
    end
    context '#list キーワードリスト' do
    end
  end

end
