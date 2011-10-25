require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe ClientVersion do
  describe ".ok?" do
    let(:version) { "2011-1024-1753" }

    before(:each) do
      Cfg.stub(:required_client_version).and_return(version)
    end

    it "should return true if it's a development version" do
      ClientVersion.ok?(ClientVersion::DEV_VERSION).should be_true
    end

    it "should return true if client version is recent enough" do
      ClientVersion.ok?(version).should be_true
    end

    it "should return false if it is too old" do
      ClientVersion.ok?("2011-1024-1752").should be_false
    end

    it "should return false if it is malformed" do
      ClientVersion.ok?("1024-1752").should be_false
    end
  end

  describe ".parse" do
    it "should return Time when successfull" do
      version = "2011-1024-1753"
      ClientVersion.parse(version).strftime(ClientVersion::VERSION_STR).
        should == version
    end

    it "should return nil when malformed" do
      ClientVersion.parse("2011-2011-1011").should be_nil
    end
  end
end