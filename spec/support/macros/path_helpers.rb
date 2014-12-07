module PathHelpers
  TEMP_PATH = File.expand_path("../../../../tmp/", __FILE__)
  COURSE_DIR_NAMES = ['Course_A', 'Course_B']
  CHAPTER_DIR_NAMES = ['Chapter-1', 'Chapter-2']
  UNIT_DIR_NAMES = ['unit-1', 'unit-2']
  TASK_NAME = 'task.md'
  REFERENCE_SOLUTION_NAME = 'solution.rb'

  def temp_basepath
    TEMP_PATH
  end

  def test_basepath
    File.join(TEMP_PATH, 'test')
  end

  def course_dir_names
    COURSE_DIR_NAMES
  end

  def chapter_dir_names
    CHAPTER_DIR_NAMES
  end

  def unit_dir_names
    UNIT_DIR_NAMES
  end

  def task_name
    TASK_NAME
  end

  def reference_solution_name
    REFERENCE_SOLUTION_NAME
  end

  def courses_basepath
    File.join(TEMP_PATH, 'courses')
  end

  def course_dirs
    course_dir_names.map do |dir|
      File.join(courses_basepath, dir)
    end
  end

  def chapter_dirs(course_name)
    chapter_dir_names.map do |chapter|
      File.join(courses_basepath, course_name, chapter)
    end
  end

  def unit_dirs(course_name)
    chapter_dir_names.map do |chapter|
      unit_dir_names.map do |unit|
        File.join(courses_basepath, course_name, chapter, unit)
      end
    end
  end

  def course_titles
    gsub_underscores(course_dir_names)
  end

  def chapter_titles
    gsub_underscores(chapter_dir_names)
  end

  def unit_titles
    gsub_underscores(unit_dir_names)
  end

  def gsub_underscores(names)
    names.map { |unit| unit.gsub(/\_+/, ' ') }
  end
end
