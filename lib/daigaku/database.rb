require 'yaml/store'
require 'fileutils'

module Daigaku

  class Database
    include Singleton

    attr_reader :file

    def initialize
      @file = Daigaku.config.storage_file
      directory = File.dirname(@file)
      FileUtils.makedirs(directory) unless Dir.exist?(directory)

      @db =  YAML::Store.new(@file)
    end

    def set(key, value)
      @db.transaction { @db[key.to_s] = value }
    end

    def get(key)
      @db.transaction { @db[key.to_s] }
    end

    def self.get(key)
      instance.get(key)
    end

    def self.set(key, value)
      instance.set(key, value)
    end

    def self.file
      instance.file
    end

    # Defines getter and setter methods for arbitrarily named methods.
    # @xample
    #   Diagaku::Database.answer = 42
    #   => saves 'answer: 42' to database
    #
    #   Daigaku::Database.answer
    #   => 42
    def self.method_missing(method, *args, &block)
      if method =~ /.*=$/
        if singleton_methods.include?(method.to_s.chop.to_sym)
          raise "There is a \"#{method.to_s.chop}\" instance method already " +
            "defined. This will lead to problems while getting values " +
            "from the database. Please use another key than " +
            "#{singleton_methods.map(&:to_s)}."
        end

        instance.set(method.to_s.gsub(/=$/, ''), args[0])
      elsif args.count == 0
        instance.get(method)
      else
        super
      end
    end
  end

end
