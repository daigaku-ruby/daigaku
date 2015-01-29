require 'spec_helper'

describe Daigaku::Database do

  subject { Daigaku::Database.send(:new) }

  before do
    Daigaku::config.instance_variable_set(:@storage_file, local_storage_file)
  end

  it "creates the database file(s) in the .daigaku directory on access" do
    Daigaku::Database.instance.call_an_arbitrary_method
    expect(File.exist?(local_storage_file)).to be_truthy
  end

  it "allows setting arbitrary keys by setter methods" do
    expect { Daigaku::Database.instance.ise_cream = "vanilla choco" }
      .not_to raise_error
  end

  it "allows getting subsequently set keys" do
    Daigaku::Database.instance.sushi = "sushi"
    expect(Daigaku::Database.instance.sushi).to eq "sushi"
  end

  it "returns nil for not set keys" do
    expect(Daigaku::Database.instance.hamburger).to be_nil
  end

  it "raises an method missing errror for non getter/setter methods" do
    expect { Daigaku::Database.instance.arbitrary_method(1, 2) }
      .to raise_error NoMethodError
  end
end