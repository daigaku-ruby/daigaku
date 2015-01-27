require 'spec_helper'

describe Daigaku::Database do

  subject { Daigaku::Database.send(:new) }

  before do
    Daigaku::config.instance_variable_set(:@storage_file, local_storage_file)
  end

  it { is_expected.to be_a YAML::Store }
end