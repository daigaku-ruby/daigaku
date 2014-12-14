module Daigaku

  class TestResult
    require 'json'

    attr_reader :examples, :example_count, :failure_count

    TEST_PASSED_MESSAGE = "Your code passed all tests. Congratulations!"

    def initialize(result_json)
      @result = JSON.parse(result_json, symbolize_names: true)

      @example_count = @result[:summary][:example_count]
      @failure_count = @result[:summary][:failure_count]

      @examples = @result[:examples].map do |example|
        description = example[:description]
        status = example[:status]
        exception = example[:exception]
        message = exception ? exception[:message] : nil

        TestExample.new(description: description, status: status, message: message)
      end
    end

    def passed?
      @examples.reduce(true) do |passed, example|
        passed && example.status == 'passed'
      end
    end

    def summary
      if passed?
        TEST_PASSED_MESSAGE
      else
        build_failed_summary
      end
    end

    private

    def build_failed_summary
      message = examples.map do |example|
        "#{example.description}\n#{example.status}: #{example.message}"
      end

      width = 50
      wrapper = "\n" + "-" * width + "\n"
      summary = wrapper + message.join("\n\n") + wrapper
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
  end

end
