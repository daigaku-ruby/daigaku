require 'fileutils'

module Daigaku
  class Test
    CODE_REGEX = /\[\['solution::code'\]\]/

    attr_reader :path

    def initialize(path)
      @unit_path = path
      @path      = Dir[File.join(path, '*spec.rb')].first
    end

    def run(solution_code)
      spec_code         = File.read(@path)
      patched_spec_code = insert_code(spec_code, solution_code.to_s)

      temp_spec = File.join(File.dirname(@path), "temp_#{File.basename(@path)}")
      create_temp_spec(temp_spec, patched_spec_code)

      result = `rspec --color --format j #{temp_spec}`
      remove_file(temp_spec)

      TestResult.new(result)
    end

    private

    def insert_code(spec, code)
      spec.gsub(CODE_REGEX, code)
    end

    def create_temp_spec(path, content)
      base_path = File.dirname(path)
      FileUtils.mkdir_p(base_path) unless Dir.exist?(base_path)
      File.open(path, 'w') { |f| f.puts content }
    end

    def remove_file(path)
      FileUtils.rm(path) if File.exist?(path)
    end
  end
end
