require 'yaml/store'
require 'fileutils'

module Daigaku

  class Database
    include Singleton

    KEY_SPLIT = '/'

    attr_reader :file

    def initialize
      @file = Daigaku.config.storage_file
      directory = File.dirname(@file)
      FileUtils.makedirs(directory) unless Dir.exist?(directory)

      @db = YAML::Store.new(@file)
    end

    # Sets the value for the given key.
    # If the key is of structure "a/b/c" then the value is saved as a nested
    # Hash, like: { a: { b: { c: value} } }.
    def set(key, value)
      keys = key.to_s.split(KEY_SPLIT)
      base_key = keys.shift

      if keys.empty?
        final_value = value
      else
        final_value = keys.reverse.inject(value) { |v, k| { k => v } }
      end

      old_value = get(base_key)

      if old_value.is_a? Hash
        updated_values = old_value ? old_value.deep_merge(final_value) : final_value
      else
        updated_values = final_value
      end

      @db.transaction { @db[base_key.to_s] = updated_values }
    end

    # Gets the value for the given key.
    # If the value was saved for a key of structure "a/b/c" then the value is
    # searched in a nested Hash, like: { a: { b: { c: value} } }.
    # If there is a value stored within a nested hash, it returns the appropriate
    # Hash if a partial key is used.
    #   e.g. get('a') return { b: { c: value }}
    #        get('a/b') returns { c: value }
    def get(key)
      keys = key.to_s.split(KEY_SPLIT)
      base_key = keys.shift

      @db.transaction do
       data = @db[base_key.to_s]

       if data
         keys.reduce(data) { |value, key| value ? value = value[key] : nil }
       end
     end
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
