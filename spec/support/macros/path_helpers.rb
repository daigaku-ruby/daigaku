module PathHelpers
  LOCAL_DIR               = '.daigaku'.freeze
  CONFIGURATION_FILE      = 'daigaku.settings'.freeze
  COURSES                 = 'courses'.freeze
  SOLUTIONS               = 'solutions'.freeze
  TEMP_PATH               = File.expand_path('../../../../tmp/', __FILE__).freeze
  COURSE_DIR_NAMES        = %w(Course_A Course_B).freeze
  CHAPTER_DIR_NAMES       = %w(1_Chapter-A 2_Chapter-B).freeze
  UNIT_DIR_NAMES          = %w(1_unit-a 2_unit-b).freeze
  TASK_NAME               = 'task.md'.freeze
  REFERENCE_SOLUTION_NAME = 'solution.rb'.freeze
  TEST_NAME               = 'solution_spec.rb'.freeze
  STORAGE_FILE            = 'daigaku.db.yml'.freeze

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

  def test_name
    TEST_NAME
  end

  def courses_basepath
    File.join(test_basepath, LOCAL_DIR, COURSES)
  end

  def solutions_basepath
    File.join(test_basepath, SOLUTIONS)
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

  def all_unit_dirs
    dirs = course_dirs.map do |course_dir|
      chapter_dir_names.map do |chapter_name|
        unit_dir_names.map do |unit_name|
          File.join(course_dir, chapter_name, unit_name)
        end
      end
    end

    dirs.flatten
  end

  def all_solution_file_paths
    all_unit_dirs.map do |unit_dir|
      underscored_unit_dir = File.basename(unit_dir).gsub(/[\_\-\.]+/, '_')
      file_name = underscored_unit_dir + Daigaku::Solution::FILE_SUFFIX

      unit_path = File.join(solutions_basepath, unit_dir.split('/')[-3..-1])
      parts     = File.join(File.dirname(unit_path), file_name).split('/')

      course_parts = parts[-3..-1].map do |part|
        part.gsub(/^[\d]+\_/, '').gsub(/[\_\-]+/, '_').downcase
      end

      (parts[0...-3] + course_parts).join('/')
    end
  end

  def all_test_file_paths
    all_unit_dirs.map do |unit_dir|
      File.join(unit_dir, test_name)
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

  def local_courses_path
    local_path = File.join(test_basepath, LOCAL_DIR, COURSES)
    File.expand_path(local_path, __FILE__)
  end

  def local_configuration_file
    local_path = File.join(test_basepath, LOCAL_DIR, CONFIGURATION_FILE)
    File.expand_path(local_path, __FILE__)
  end

  def local_storage_file
    local_path = File.join(test_basepath, LOCAL_DIR, STORAGE_FILE)
    File.expand_path(local_path, __FILE__)
  end
end
