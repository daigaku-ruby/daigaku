module Daigaku

  class TestResult
    require 'json'

    attr_reader :examples, :example_count, :failure_count

    def initialize(result_json)
      @result = begin
        JSON.parse(result_json, symbolize_names: true)
      rescue
        syntax_error_json
      end

      @example_count = @result[:summary][:example_count]
      @failure_count = @result[:summary][:failure_count]

      @examples = @result[:examples].map do |example|
        description = example[:full_description]
        status = example[:status]
        exception = example[:exception]
        message = exception ? exception[:message] : nil

        TestExample.new(description: description, status: status, message: message)
      end
    end

    def passed?
      @examples.reduce(true) do |passed, example|
        passed && example.passed?
      end
    end

    def summary
      if passed?
        "Your code passed all tests. #{Daigaku::Congratulator.message}"
      else
        build_failed_summary
      end
    end

    def summary_lines
      summary.lines.map(&:strip)
    end

    private

    def build_failed_summary
      message = examples.map do |example|
        "#{example.description}\n#{example.status}: #{example.message}"
      end

      summary = message.map(&:strip).join("\n" * 3)
    end

    def syntax_error_json
      {
        summary: {},
        examples: [
          {
            status: 'failed',
            exception: { message: ":( You got a syntax error in your code!" }
          }
        ]
      }
    end
  end

  class TestExample

    attr_reader :description, :status, :message

    EXAMPLE_PASSED_MESSAGE = "Your code passed this requirement."

    def initialize(args = {})
      @description = args[:description]
      @status = args[:status]
      @message = args[:message] || EXAMPLE_PASSED_MESSAGE
    end

    def passed?
      @status == 'passed'
    end
  end

end
