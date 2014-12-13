require 'spec_helper'

describe "Daigaku module" do

  describe "::config" do

    subject { Daigaku.config }

    [:config, :configure, :start, :default_panel].each do |method|
      it "responds to ::#{method}" do
        expect(Daigaku.singleton_methods).to include method
      end
    end

    it "returns Configuration of class Daigaku::Configuration" do
      expect(subject).to be_an_instance_of Daigaku::Configuration
    end

    it "returns a singleton setting" do
      expect(subject).to be Daigaku.config
    end
  end

  describe "::configure" do

    let(:configure) do
      proc do
        Daigaku.configure do |config|
          config.solutions_path = test_basepath
        end
      end
    end

    it "allows to configure the app" do
      expect { configure.call }.not_to raise_error
    end

    it "sets configutation properties" do
      configure.call
      expect(Daigaku.config.solutions_path).to eq test_basepath
    end

    it "allows to change the config during runtime" do
      Daigaku.configure do |config|
        config.solutions_path = courses_basepath
      end

      expect(Daigaku.config.solutions_path).to eq courses_basepath
    end
  end

end
