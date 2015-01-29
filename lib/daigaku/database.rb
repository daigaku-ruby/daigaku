require 'yaml/store'
require 'fileutils'

module Daigaku

  class Database
    include Singleton

    def initialize
      db_file = Daigaku.config.storage_file
      directory = File.dirname(db_file)
      FileUtils.makedirs(directory) unless Dir.exist?(directory)

      @db =  YAML::Store.new(db_file)
    end

    # Defines getter and setter methods for arbitrarily named methods.
    # @xample
    #   Diagaku::Database.instance.answer = 42
    #   => saves 'anser: 42' to database
    #
    #   Daigaku::Database.instance.answer
    #   => 42
    def method_missing(method, *args, &block)
      if method =~ /.*=$/
        @db.transaction { @db[method.to_s.gsub(/=$/, '')] = args[0] }
      elsif args.count == 0
        @db.transaction { @db[method.to_s] }
      else
        super
      end
    end
  end

end
