require 'spec_helper'

describe Daigaku::Loading::Chapters do
  before :all do
    @subjects = Daigaku::Loading::Chapters.load(course_dirs.first)
  end

  it "has the prescribed number of chapters" do
    expect(@subjects.count).to eq available_chapters(course_dirs.first).count
  end

  it "loads the available chapters" do
    @subjects.each_with_index do |chapter, index|
      expect(chapter.title).to eq chapter_titles[index]
    end
  end
end