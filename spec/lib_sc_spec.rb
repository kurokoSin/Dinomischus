require_relative '../lib_sc.rb'

RSpec.describe SecureConf do
  let(:test_path){ File.join(__dir__,'Assets/sc_default.yml') }
  let(:sc1){ SecureConf.new( test_path ) }
  let(:sc4){ SecureConf.new( test_path, params[0], params[1], params[2]) }

  describe '#initialize コンストラクタ' do
    context '引数がないとき' do
      it 'エラーになること' do
        expect{ SecureConf.new() }.to raise_error( ArgumentError )
        # expect{ SecureConf.new([]) }.to raise_error( ArgumentError )
        # expect{ SecureConf.new(nil) }.to raise_error( ArgumentError )
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
    context '引数が ２つ or ３つ のとき' do
      it 'エラーになること' do
        expect{ SecureConf.new(:hogehoge, :fugafuga) }.to raise_error( ArgumentError )
        expect{ SecureConf.new(:hogehoge, :fugafuga, :halahala) }.to raise_error( ArgumentError )
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

  describe '#get 読込' do
    context 'Rubyで使用するとき、' do
      let(:sc){ SecureConf.new( File.join(__dir__, 'Assets/sc_default.yml') ) }
      it '平文の読込ができること' do
        expect(sc.get("key_")).to eq "value_"
      end
      it '暗号化された値の読込ができること' do
        expect(sc.get("key1")).to eq "value1"
      end
    end
    context 'シェルで使用するとき、' do
      let(:sc){ SecureConf.new( './Assets/sc_default.yml' ) }
      it '平文の読込ができること' do
        expect( system('sc -r key_') ).to eq "value_"
      end
      it '暗号化された値の読込ができること' do
        expect( system('sc -r key1') ).to eq "value1"
      end
    end
  end

  describe '#put 書込' do
    context 'Rubyで使用するとき、' do
      it '暗号化して保存すること' do
        sc = SecureConf.new()
        expect( sc.put(:enckey, :encfugafuga, true)   ).to eq ''
        expect( sc.put(key, value, True)   ).to eq ''
        expect( sc.put(key, value, "true") ).to eq ''
        expect( sc.put(key, value, :tRue)  ).to eq ''
        expect( sc.put(key, value, True, :HelpTextMessage) ).to eq ''
      end
      it '平文で保存すること' do
        sc = SecureConf.new( file_fixture("sc_default.yml") ) 
        expect( sc.put(key, value) ).to  eq ''
        expect( sc.put(key, value, nil) ).to  eq ''
        expect( sc.put(key, value, False) ).to  eq ''
        expect( sc.put(key, value, :False) ).to  eq ''
        expect( sc.put(key, value, :TrueIgai) ).to  eq ''
        expect( sc.put(key, value, :TrueIgai, :HelpTextMessage) ).to  eq ''
      end
    end
  end

end
