module ContentHelpers

  TASK_FILE_CONTENT = [
    "Heading\n======", "##Task",
    "Solve this task!",
    "##Hints",
    "Just do it right..."
  ].join("\n\n")

  SOLUTION_CONTENT = 'print "hello world".upcase'

  TEST_CONTENT = [
    "require 'rspec'\n",
    "describe 'Your code' do",
    "  it 'prints out HELLO WORLD' do",
    "    expect { [['solution::code']] }.to output('HELLO WORLD').to_stdout",
    "  end\n",
    "  it 'uses the method #upcase to get capital letters' do",
    "    allow(self).to receive(:puts).and_return ''",
    "    allow(self).to receive(:print).and_return ''",
    "    expect_any_instance_of(String).to receive(:upcase).and_return('HELLO WORLD')\n",
    "    [['solution::code']]",
    "  end",
    "end"
    ].join("\n")

  TEST_FAILED_JSON =
    %Q#
      { "examples":
        [
          { "description": "description 1",
            "full_description": "full description 1",
            "status": "failed",
            "file_path": "./spec.rb",
            "line_number": 4,
            "run_time": 0.001,
            "exception": {
              "class": "RSpec::Expectations::ExpectationNotMetError",
              "message": "message 1",
              "backtrace": ["backtrace 1_a", "backtrace 1_b"]
            }
          },
          { "description": "description 2",
            "full_description": "full description 2",
            "status": "passed",
            "file_path": "./spec.rb",
            "line_number": 8,
            "run_time": 0.002
          }
        ],
      "summary": {
        "duration": 0.003,
        "example_count": 2,
        "failure_count": 1,
        "pending_count": 0
      },
      "summary_line": "2 example, 1 failure"
    }
  #

  TEST_PASSED_JSON =
    %Q#
      { "examples":
        [
          { "description":"description 1",
            "full_description":"full description 1",
            "status":"passed",
            "file_path":"spec.rb",
            "line_number":4,
            "run_time":0.001
          },
          { "description":"description 2",
            "full_description":"full description 2",
            "status":"passed",
            "file_path":"spec.rb",
            "line_number":8,
            "run_time":0.002
          }
        ],
        "summary":{
          "duration":0.003,
          "example_count":2,
          "failure_count":0,
          "pending_count":0
        },
        "summary_line":"2 example, 0 failures"
      }
    #

  TEST_PASSED_MESSAGE = "Your code passed all tests."
  EXAMPLE_PASSED_MESSAGE = "Your code passed this requirement."

  def task_file_content
    TASK_FILE_CONTENT
  end

  def solution_content
    SOLUTION_CONTENT
  end

  def test_content
    TEST_CONTENT
  end

  def test_failed_json
    TEST_FAILED_JSON
  end

  def test_passed_json
    TEST_PASSED_JSON
  end

  def test_passed_json_parsed
    JSON.parse(test_passed_json, symbolize_names: true)
  end

  def test_failed_json_parsed
    JSON.parse(test_failed_json, symbolize_names: true)
  end

  def test_passed_summary
    TEST_PASSED_MESSAGE
  end

  def example_passed_message
    EXAMPLE_PASSED_MESSAGE
  end

end
