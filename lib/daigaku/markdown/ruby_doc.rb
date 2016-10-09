require 'cgi'

module Daigaku
  module Markdown
    class RubyDoc
      RUBY_DOC_URL    = 'http://ruby-doc.org'.freeze
      CORE_BASE_URL   = "#{RUBY_DOC_URL}/core-#{RUBY_VERSION}".freeze
      STDLIB_BASE_URL = "#{RUBY_DOC_URL}/stdlib-#{RUBY_VERSION}".freeze

      CORE_REGEX      = /\(ruby-doc core:\s?(.*)\)/
      STDLIB_REGEX    = /\(ruby-doc stdlib:\s?(.*)\)/

      class << self
        def parse(text)
          new.parse(text)
        end
      end

      def parse(text)
        parsed_text = sub_stdlib_links(text)
        sub_core_links(parsed_text)
      end

      private

      def sub_core_links(text)
        match = text.match(CORE_REGEX)
        return text if match.nil?

        match.captures.reduce(text) do |result, capture|
          result.sub!(doc_regex(:core, capture), core_link(capture))
        end
      end

      def sub_stdlib_links(text)
        match = text.match(STDLIB_REGEX)
        return text if match.nil?

        match.captures.reduce(text) do |result, capture|
          result.sub!(doc_regex(:stdlib, capture), stdlib_link(capture))
        end
      end

      def doc_regex(type, capture)
        Regexp.new(Regexp.escape("(ruby-doc #{type}: #{capture})"))
      end

      def core_link(text)
        constants = ruby_constants(text).join('/')
        method    = ruby_method(text)

        "#{CORE_BASE_URL}/#{constants}.html#{method}"
      end

      def stdlib_link(text)
        constants   = ruby_constants(text).join('/')
        method      = ruby_method(text)
        libdoc_part = "libdoc/#{ruby_stdlib(text)}/rdoc"

        "#{STDLIB_BASE_URL}/#{libdoc_part}/#{constants}.html#{method}"
      end

      # Returns the stdlib part of the url.
      # If an explicit stdlib name is defined in markdown, e.g.
      #   (ruby-doc stdlib: net/http Net::HTTP) => 'net/http'
      # then this lib name is used.
      # Else the lib is created from the constants, e.g.
      #   (ruby-doc stdlib: Time) => 'time'
      def ruby_stdlib(text)
        parts = text.split

        if parts.length > 1
          parts.first.strip.downcase
        else
          ruby_constants(text).join('/').downcase
        end
      end

      def ruby_constants(text)
        parts = text.split.last.split(/::|#/)
        select_capitalized(parts)
      end

      def ruby_method(text)
        method = text.split(/::|#/).last
        return '' unless downcased?(method)

        method_type = text =~ /#/ ? 'i' : 'c'
        method_name = CGI.escape(method.strip).tr('%', '-').gsub(/\A-/, '')
        "#method-#{method_type}-#{method_name}"
      end

      def select_capitalized(parts)
        parts.select do |part|
          part[0].match(/\w/) && part[0] == part[0].upcase
        end
      end

      def downcased?(text)
        text == text.downcase
      end
    end
  end
end
