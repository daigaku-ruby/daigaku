require 'spec_helper'

describe Daigaku::Loading::Courses do
  before :all do
    @subjects = Daigaku::Loading::Courses.load(courses_basepath)
  end

  it "has the prescribed number of courses" do
    expect(@subjects.count).to eq available_courses.count
  end

  it "loads the available courses" do
    @subjects.each_with_index do |course, index|
      expect(course.title).to eq course_titles[index]
    end
  end
end