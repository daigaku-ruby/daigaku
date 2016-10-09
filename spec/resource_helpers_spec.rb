require 'spec_helper'

describe 'ResourceHelpers' do
  let(:course) { course_dir_names.first }
  let(:chapter) { chapter_dir_names.first }
  let(:unit) { unit_dir_names.first }

  it 'provides the available courses' do
    puts "\n* available courses:"
    puts available_courses.map(&:inspect)
  end

  it 'provides a course’s available chapters' do
    puts "\n* available chapters:"
    puts available_chapters(course).map(&:inspect)
  end

  it 'provides a chapter’s avaliable units' do
    puts "\n* available units:"
    puts available_units(course, chapter).map(&:inspect)
  end

  it 'provides a unit’s task file' do
    puts "\n* task:"
    puts available_task(course, chapter, unit).map(&:inspect)
  end

  it 'provides a unit’s reference solution file' do
    puts "\n* reference solution:"
    puts available_reference_solution(course, chapter, unit).map(&:inspect)
  end
end
