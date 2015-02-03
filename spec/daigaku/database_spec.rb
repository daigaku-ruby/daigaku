require 'spec_helper'

describe Daigaku::Database do

  subject { Daigaku::Database.send(:new) }

  before do
    Daigaku::config.instance_variable_set(:@storage_file, local_storage_file)
  end

  it { is_expected.to respond_to :get }
  it { is_expected.to respond_to :set }

  it "creates the database file(s) in the .daigaku directory on access" do
    Daigaku::Database.call_an_arbitrary_method
    expect(File.exist?(local_storage_file)).to be_truthy
  end

  it "allows setting arbitrary keys by setter methods" do
    expect { Daigaku::Database.brownie = "brownie" }
      .not_to raise_error
  end

  it "allows getting subsequently set keys" do
    Daigaku::Database.carrots = "carrots"
    expect(Daigaku::Database.carrots).to eq "carrots"
  end

  it "returns nil for not set keys" do
    expect(Daigaku::Database.hamburger).to be_nil
  end

  it "raises an method missing errror for non getter/setter methods" do
    expect { Daigaku::Database.arbitrary_method(1, 2) }
      .to raise_error NoMethodError
  end

  it "responds to ::get" do
    expect(Daigaku::Database).to respond_to :get
  end

  it "responds to ::set" do
    expect(Daigaku::Database).to respond_to :set
  end

  describe "::get" do
    it "returns the value of the given key" do
      toast = 'toast'
      Daigaku::Database.toast = toast
      expect(Daigaku::Database.get :toast).to eq toast
    end
  end

  describe "::set" do
    it "sets the value for the given key" do
      juice = 'orange juice'
      Daigaku::Database.set :juice, juice
      expect(Daigaku::Database.juice).to eq juice
    end
  end

  it "raises an error if the related getter for a setter is already defined" do
    expect { Daigaku::Database.clone = 'defined' }.to raise_error
  end
end
