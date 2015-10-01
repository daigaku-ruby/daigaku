require 'cgi'

module Daigaku
  class Markdown
    class RubyDoc

      RUBY_DOC_URL    = "http://ruby-doc.org".freeze
      CORE_BASE_URL   = "#{RUBY_DOC_URL}/core-#{RUBY_VERSION}".freeze
      STDLIB_BASE_URL = "#{RUBY_DOC_URL}/stdlib-#{RUBY_VERSION}".freeze

      CORE_REGEX      = /\(ruby-doc core:\s?(.*)\)/.freeze
      STDLIB_REGEX    = /\(ruby-doc stdlib:\s?(.*)\)/.freeze

      class << self
        def parse(text)
          case text
          when CORE_REGEX
            core_link(text.match(CORE_REGEX).captures.first)
          when STDLIB_REGEX
            stdlib_link(text.match(STDLIB_REGEX).captures.first)
          end
        end

        def core_link(text)
          new.core_link(text)
        end

        def stdlib_link(text)
          new.stdlib_link(text)
        end
      end

      def core_link(text)
        constants = ruby_constants(text).join('/')
        method = ruby_method(text)

        "#{CORE_BASE_URL}/#{constants}.html#{method}"
      end

      def stdlib_link(text)
        constants = ruby_constants(text).join('/')
        method = ruby_method(text)
        libdoc_part = "libdoc/#{ruby_stdlib(text)}/rdoc"

        "#{STDLIB_BASE_URL}/#{libdoc_part}/#{constants}.html#{method}"
      end

      private

      # Returns the stdlib part of the url.
      # If an explicit stdlib name is defined in markdown, e.g.
      #   (ruby-doc stdlib: net/http Net::HTTP) => 'net/http'
      # then this lib name is used.
      # Else the lib is created from the constants, e.g.
      #   (ruby-doc stdlib: Time) => 'time'
      def ruby_stdlib(text)
        parts = text.split(' ')

        if parts.length > 1
          parts.first.strip.downcase
        else
          ruby_constants(text).join('/').downcase
        end
      end

      def ruby_constants(text)
        parts = text.split(' ').last.split(/::|#/)
        select_capitalized(parts)
      end

      def ruby_method(text)
        method = text.split(/::|#/).last
        return '' unless downcased?(method)

        method_type = text.match(/#/) ? 'i' : 'c'
        method_name = CGI.escape(method.strip).gsub('%', '-').gsub(/\A-/, '')
        "#method-#{method_type}-#{method_name}"
      end

      def select_capitalized(parts)
        parts.select { |part| part[0] == part[0].upcase }
      end

      def downcased?(text)
        text == text.downcase
      end

    end
  end
end
