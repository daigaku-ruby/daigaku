require 'json'

module Daigaku
  class TestResult
    CODE_ERROR_MESSAGE = ':( You got an error in your code!'.freeze

    attr_reader :examples, :example_count, :failure_count

    def initialize(result_json)
      @result = begin
        JSON.parse(result_json, symbolize_names: true)
      rescue => error
        syntax_error_json(error)
      end

      @example_count = @result.dig(:summary, :example_count)
      @failure_count = @result.dig(:summary, :failure_count)
      error_count = @result.dig(:summary, :errors_outside_of_examples_count) || 0

      if error_count > 0
        @failure_count = error_count
        details = error_details(@result)
        @result = error_json(details)
      end

      @examples = @result[:examples].map do |example|
        description = example[:full_description]
        status      = example[:status]
        exception   = example[:exception]
        message     = exception ? exception[:message] : nil

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
        "#{example.description}\n#{example.status}: #{example.message}".strip
      end

      message.join("\n" * 3)
    end

    def syntax_error_json(error)
      details = failure_details(error)
      error_json(details)
    end

    def error_details(result)
      result[:messages]
        .first
        .split('\n')
        .each_with_index
        .select { |line, index| index > 0 && line.matches?(/temp_.+\.rb/) }
        .first.to_s
    end

    def error_json(details)
      {
        summary: {},
        examples: [
          {
            status: TestExample::FAILED,
            exception: { message: "#{CODE_ERROR_MESSAGE}\n\n#{details}" }
          }
        ]
      }
    end

    def failure_details(error)
      line = error.backtrace.first
      error_message = remove_colorization(error.message)
      "#{error.class} in #{line}:\n#{error_message}"
    end

    def remove_colorization(text)
      text.gsub(/\x1b\[[0-9]*m/i, '')
    end
  end

  class TestExample
    PASSED = 'passed'.freeze
    FAILED = 'failed'.freeze

    attr_reader :description, :status, :message

    EXAMPLE_PASSED_MESSAGE = 'Your code passed this requirement.'.freeze

    def initialize(status:, description: nil, message: nil)
      @description = description
      @status      = status
      @message     = message || EXAMPLE_PASSED_MESSAGE
    end

    def passed?
      @status == PASSED
    end
  end
end
