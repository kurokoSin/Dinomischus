RSpec.describe Dinomischus do
  it "has a version number" do
    expect(Dinomischus::VERSION).not_to be nil
  end

  describe "Load config File" do
    let(:config_file){ "#{RSPEC_ROOT}/resources/config/config_base.yml" }

    it "when display the list" do
      hash = Dinomischus.load_file(config_file)  # also project_name_config.yml 
      expect( hash[:userId] ).to eq "sampleUserId"      # => raw-value 
      expect( hash[:password] ).to eq "samplePassword"  # => decrypted-description 
      expect( hash[:"e-mail"] ).to eq "someone@example.com" # => raw-description 
    end
  end

  xdescribe "Command Test" do
    let(:config_file){ "#{RSPEC_ROOT}/resources/config/config_base.yml" }

    it "dinomischus -g -f [FileName] -k [key]" do
        expect{ system("./exe/dinomischus -g -f #{config_file} -k userId") }.to output("sampleUserId").to_stdout 
    end
  end
end

