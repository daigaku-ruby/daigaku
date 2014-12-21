module Daigaku
  module Terminal

    # text should be of a width of 70 columns or less
    def self.text(file_name)
      texts_path = File.expand_path('../terminal/texts', __FILE__)
      File.read(File.join(texts_path, "#{file_name.to_s}.txt"))
    end

  end
end
