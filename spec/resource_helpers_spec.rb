require 'spec_helper'

describe "ResourceHelpers" do

  let(:course) { course_dir_names.first }
  let(:chapter) { chapter_dir_names.first }
  let(:unit) { unit_dir_names.first }

  it "provides the available courses" do
    puts "\navailable courses: #{available_courses}"
  end

  it "provides a course's available chapters" do
    puts "\navailable chapters: #{available_chapters(course)}"
  end

  it "provides a chapter's avaliable units" do
    puts "\navailable units: #{available_units(course, chapter)}"
  end

  it "provides a unit's task file" do
    puts "\ntask: #{available_task(course, chapter, unit)}"
  end

  it "provides a unit's reference solution file" do
    puts "\nreference solution: #{available_reference_solution(course, chapter, unit)}"
  end
end