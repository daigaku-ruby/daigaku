require 'spec_helper'

describe "PathHelpers" do

  it "provides a temp base path" do
    puts "\n* temp base path:"
    puts temp_basepath
  end

  it "provides a test base path" do
    puts "\n* test base path:"
    puts test_basepath
  end

  it "provides a courses base path" do
    puts "\n* courses base path:"
    puts courses_basepath
  end

  it "provides the course directories" do
    puts "\n* course dirs:"
    puts course_dirs
  end

  it "provides each course's chapter directories" do
    puts "\n* chapter dirs: "

    course_dir_names.each do |course_name|
      puts chapter_dirs(course_name)
    end
  end

  it "provides each chapter's unit directories" do
    puts "\n* unit dirs:"

    course_dir_names.each do |course_name|
      puts unit_dirs(course_name)
    end
  end

  it "provides all unit directories as flattened array" do
    puts "\n* all unit dirs:"
    puts all_unit_dirs
  end

  it "provides all solution file paths" do
    puts "\n* all solution file paths:"
    puts all_solution_file_paths
  end

  it "provides all test file paths" do
    puts "\n* all test file paths:"
    puts all_test_file_paths
  end
end
