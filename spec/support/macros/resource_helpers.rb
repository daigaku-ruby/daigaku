require 'fileutils'
require 'zip'

module ResourceHelpers
  def prepare_courses
    FileUtils.mkdir_p(courses_basepath) unless Dir.exist?(courses_basepath)

    course_dir_names.each do |course|
      chapter_dir_names.each do |_|
        unit_dirs(course).each do |units|
          units.each do |unit|
            create_directory(unit)
            create_file(unit, task_name, task_file_content)
            create_file(unit, reference_solution_name, solution_content)
            create_file(unit, test_name, test_content)
          end
        end
      end
    end
  end

  def prepare_github_course
    prepare_courses
    github_course_dir = "#{course_dirs.first}-master/"
    FileUtils.copy_entry("#{course_dirs.first}/", github_course_dir)
    github_course_dir
  end

  def prepare_solutions
    all_solution_file_paths.each do |path|
      base_dir = File.dirname(path)
      name     = File.basename(path)
      create_file(base_dir, name, solution_content)
    end
  end

  def prepare_download(zip_file_name, options = {})
    zip_file_path = File.join(courses_basepath, zip_file_name)

    unless Dir.exist?(File.dirname(zip_file_path))
      FileUtils.makedirs(File.dirname(zip_file_path))
    end

    Zip::File.open(zip_file_path, Zip::File::CREATE) do |zip_file|
      Dir[File.join(courses_basepath, '**', '**')].each do |file|
        if course_match?(file, options[:multiple_courses])
          zip_file.add(file.sub(courses_basepath, '')[1..-1], file) { true }
        end
      end
    end

    File.read(zip_file_path)
  end

  def prepare_github_download(zip_file_name)
    zip_file_path = File.join(courses_basepath, zip_file_name)

    unless Dir.exist?(File.dirname(zip_file_path))
      FileUtils.makedirs(File.dirname(zip_file_path))
    end

    Zip::File.open(zip_file_path, Zip::File::CREATE) do |zip_file|
      Dir[File.join(courses_basepath, '**', '**')].each do |file|
        if file =~ /.*\-master/
          zip_file.add(file.sub(courses_basepath, '')[1..-1], file) { true }
        end
      end
    end

    File.read(zip_file_path)
  end

  def course_match?(name, multiple_courses)
    if multiple_courses
      name.match(course_dirs.first) || name.match(course_dirs.second)
    else
      name.match(course_dirs.first)
    end
  end

  def cleanup_download(zip_file_name)
    directory = course_dirs.first
    zip_file  = File.join(File.dirname(directory), zip_file_name)
    FileUtils.rm(zip_file) if File.exist?(zip_file)
  end

  def cleanup_temp_data
    FileUtils.remove_dir(temp_basepath) if Dir.exist?(temp_basepath)
  end

  def create_directory(dir_path)
    FileUtils.mkdir_p(dir_path) unless Dir.exist?(dir_path)
  end

  def create_file(base_dir, name, content)
    create_directory(base_dir) unless Dir.exist?(base_dir)
    file_path = File.join(base_dir, name)

    return unless Dir.exist?(base_dir)
    File.open(file_path, 'w') { |f| f.puts content }
  end

  def available_courses
    course_dirs.map do |path|
      Daigaku::Course.new(path)
    end
  end

  def available_chapters(course_name)
    chapter_dirs(course_name).map do |path|
      Daigaku::Chapter.new(path)
    end
  end

  def available_units(course_name, chapter_name)
    units = unit_dirs(course_name).map do |unit_dir|
      unit_dir.map do |path|
        next unless path.split('/')[-2] == chapter_name
        Daigaku::Unit.new(path)
      end
    end

    units.map(&:compact).flatten
  end

  def available_task(course_name, chapter_name, unit_name)
    task = unit_dirs(course_name).map do |units|
      units.map do |path|
        split = path.split('/')
        next if split[-2] != chapter_name || split[-1] != unit_name

        Daigaku::Task.new(path)
      end
    end

    task.map(&:compact).flatten
  end

  def available_reference_solution(course_name, chapter_name, unit_name)
    solution = unit_dirs(course_name).map do |units|
      units.map do |path|
        split = path.split('/')
        next if split[-2] != chapter_name || split[-1] != unit_name

        Daigaku::ReferenceSolution.new(path)
      end
    end

    solution.map(&:compact).flatten
  end

  def available_solution(course_name, chapter_name, unit_name)
    path = File.join(solutions_basepath, course_name, chapter_name, unit_name)
    Daigaku::Solution.new(path)
  end
end
