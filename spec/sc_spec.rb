RSpec.describe SecureConf do
  let(:my_conf){ "hogehoge" }
  let(:sc){ SecureConf.new( my_conf ) }

  describe '#initialize コンストラクタ' do
    it 'インスタンスが作成されること' do
      expect( sc.nil? ).to be_falsey

      sc2 = SecureConf.new( my_conf, :ed25519, '~/.ssh/id_ed25519.pub', '~/.ssh/id_ed25519' ) 
      expect( sc2.nil? ).to be_falsey
    end
    it '引数の数が合わないので、エラーになること' do
      expect{ SecureConf.new() }.to raise_error( ArgumentError )
      expect{ SecureConf.new(:hogehoge, :fugafuga) }.to raise_error( ArgumentError )
      expect{ SecureConf.new(:hogehoge, :fugafuga, :halahala) }.to raise_error( ArgumentError )
    end
  end

  describe '#add 書込' do
    context 'Rubyで使用するとき、' do
      it '暗号化して保存すること' do
        sc = SecureConf.new()
        expect( sc.add(:enckey, :encfugafuga, true)   ).to eq ''
        expect( sc.add(key, value, True)   ).to eq ''
        expect( sc.add(key, value, "true") ).to eq ''
        expect( sc.add(key, value, :tRue)  ).to eq ''
        expect( sc.add(key, value, True, :HelpTextMessage) ).to eq ''
      end
      it '平文で保存すること' do
        sc = SecureConf.new( file_fixture("sc_default.yml") ) 
        expect( sc.add(key, value) ).to  eq ''
        expect( sc.add(key, value, nil) ).to  eq ''
        expect( sc.add(key, value, False) ).to  eq ''
        expect( sc.add(key, value, :False) ).to  eq ''
        expect( sc.add(key, value, :TrueIgai) ).to  eq ''
        expect( sc.add(key, value, :TrueIgai, :HelpTextMessage) ).to  eq ''
      end
    end
  end

  describe '#read 読込' do
    context 'Rubyで使用するとき、' do
      it 'Exist ' do
        sc = SecureConf.new( file_fixture("sc_default.yml") ) 
        expect(sc.read(:key_)).to eq :value_
      end
    end
    context 'シェルで使用するとき、' do
      it 'Exist ' do
        sc = SecureConf.new( file_fixture("sc_default.yml") ) 
        expect( system('sc -r key_') ).to eq :value_
      end
    end
  end
end
