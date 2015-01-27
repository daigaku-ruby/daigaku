require 'yaml/store'
require 'fileutils'

module Daigaku

  class Database < YAML::Store
    include Singleton

    def initialize
      db_file = Daigaku.config.storage_file
      FileUtils.makedirs(File.dirname(db_file))

      @db = super(db_file)
    end
  end

end