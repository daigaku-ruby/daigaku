module MockHelpers

  def mock_default_window
    allow_any_instance_of(described_class).to receive(:default_window) { true }
  end

  def use_test_storage_file
    Daigaku::Configuration.send(:new)
    Daigaku.config.instance_variable_set(:@storage_file, local_storage_file)
  end
end
