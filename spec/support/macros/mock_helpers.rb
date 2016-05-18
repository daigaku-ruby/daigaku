module MockHelpers
  def mock_default_window
    allow_any_instance_of(described_class).to receive(:default_window) { true }
  end

  def use_test_storage_file
    Daigaku::Configuration.send(:new)
    Daigaku.config.instance_variable_set(:@storage_file, local_storage_file)

    QuickStore.configure do |config|
      config.file_path = Daigaku.config.storage_file
    end

    QuickStore.store.send(:new)
  end

  def suppress_print_out
    allow(described_class).to receive(:say_warning)
    allow(described_class).to receive(:say_info)
    allow(described_class).to receive(:say)

    allow($stdout).to receive(:puts)
    allow($stdout).to receive(:print)
  end
end
