module Daigaku
  require 'fileutils'

  class Generator

    TARGET_DIRECTORY = '.daigaku'
    CONFIG_FILE = 'config'

    def scaffold(path)

    end

    def prepare
      target_dir = File.expand_path("~/#{TARGET_DIRECTORY}", __FILE__)
      create_local_dir(target_dir)
      create_local_config(target_dir)
    end

    private

    def create_local_dir(target_dir)
      FileUtils.mkdir(target_dir) unless Dir.exist?(target_dir)
    end

    def create_local_config(target_dir)
      if Dir.exist?(target_dir)
        file = File.join(target_dir, CONFIG_FILE)
        File.open(file, 'w')
      end
    end
  end
end