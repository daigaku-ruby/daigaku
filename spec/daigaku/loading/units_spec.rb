require 'spec_helper'

describe Daigaku::Loading::Units do

  let(:course_name) { course_dir_names.first }
  let(:chapter_path) { chapter_dirs(course_name).first }
  let(:chapter_name) { File.basename(chapter_path) }

  let(:subjects) { Daigaku::Loading::Units.load(chapter_path) }

  it "has the prescribed number of units" do
    units_count = available_units(course_name, chapter_name).count
    expect(subjects.count).to eq units_count
  end

  it "loads the available units" do
    subjects.each_with_index do |unit, index|
      expect(unit.title).to eq unit_titles[index]
    end
  end
end