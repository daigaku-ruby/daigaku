require 'spec_helper'

describe Daigaku::Loading::Units do
  before :all do
    course_name = File.basename(course_dir_names.first)
    chapter_path = chapter_dirs(course_name).first
    @subjects = Daigaku::Loading::Units.load(chapter_path)
  end

  it "has the prescribed number of units" do
    course_name = course_dir_names.first
    chapter_name = chapter_dir_names.first
    units_count = available_units(course_name, chapter_name).count
    expect(@subjects.count).to eq units_count
  end

  it "loads the available units" do
    @subjects.each_with_index do |unit, index|
      expect(unit.title).to eq unit_titles[index]
    end
  end
end