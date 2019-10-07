RSpec.describe SecureConf do
  let(:myconf){  }
  let(:sc){ SecureConf.new( my_conf ) }

  describe '#base' do
    it 'Failed Get instance ' do
      expect{ SecureConf.new() }.to raise_error( ArgumentError )
    end
    it 'Get instance' do
      expect( sc.!nil? ).to True   
    end
  end

  describe '#add  書込' do
    context 'Ruby use' do
      it 'Encrypted ' do
        sc = SecureConf.new()
        expect( sc.add(:enckey, :encfugafuga, true)   ).to eq ''
        expect( sc.add(key, value, True)   ).to eq ''
        expect( sc.add(key, value, "true") ).to eq ''
        expect( sc.add(key, value, :tRue)  ).to eq ''
        expect( sc.add(key, value, True, :HelpTextMessage) ).to eq ''
      end
      it 'Plane Text' do
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
    context 'Ruby use' do
      it 'Exist ' do
        sc = SecureConf.new( file_fixture("sc_default.yml") ) 
        expect(sc.read(:key_)).to eq :value_
      end
    end
    context 'shell use' do
      it 'Exist ' do
        sc = SecureConf.new( file_fixture("sc_default.yml") ) 
        expect( system('sc -r key_') ).to eq :value_
      end
    end
  end
end
