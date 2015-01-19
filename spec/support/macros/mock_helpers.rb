module MockHelpers

  def mock_default_window
    allow_any_instance_of(described_class).to receive(:default_window) { true }
  end
end
