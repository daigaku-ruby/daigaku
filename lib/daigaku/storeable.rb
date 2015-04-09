module Daigaku
  module Storeable

    LEADING_NUMBERS = /^\d+[\_\-\s]+/
    PART_JOINTS = /[\_\-\s]+/

    def self.key(text, options = {})
      separator = QuickStore.config.key_separator
      prefix = options[:prefix]
      suffix = clean(options[:suffix])
      suffixes = options[:suffixes]
      suffixes_items = suffixes ? suffixes.map { |s| clean(s) }.compact : nil

      [prefix, clean(text), suffix || suffixes_items].compact.join(separator)
    end

    def self.clean(text)
      text.gsub(LEADING_NUMBERS, '').gsub(PART_JOINTS, '_').downcase if text
    end
  end
end
