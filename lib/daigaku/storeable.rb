module Daigaku
  module Storeable

    LEADING_NUMBERS = /^\d+[\_\-\s]+/
    PART_JOINTS = /[\_\-\s]+/

    class << self
      def key(text, options = {})
        separator = QuickStore.config.key_separator
        prefix = options[:prefix]
        suffix = clean(options[:suffix])
        suffixes = options[:suffixes]
        suffixes_items = suffixes ? suffixes.map { |s| clean(s) }.compact : nil

        [prefix, clean(text), suffix || suffixes_items].compact.join(separator)
      end

      private

      def clean(text)
        if text
          parts = text.to_s.split(QuickStore.config.key_separator).map do |key|
            key.gsub(LEADING_NUMBERS, '').gsub(PART_JOINTS, '_').downcase
          end

          parts.join(QuickStore.config.key_separator)
        end
      end
    end

  end
end
