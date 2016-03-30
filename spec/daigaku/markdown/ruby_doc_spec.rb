require 'spec_helper'

describe Daigaku::Markdown::RubyDoc do

  [:parse].each do |class_method|
    it "responds to #{class_method}" do
      expect(Daigaku::Markdown::RubyDoc).to respond_to class_method
    end
  end

  def parse(text)
    Daigaku::Markdown::RubyDoc.parse(text)
  end

  describe '::parse' do
    context 'for a text containing a core doc markup' do
      let(:base_url) { "http://ruby-doc.org/core-#{RUBY_VERSION}" }

      it 'returns the right link for a single class' do
        markdown = '(ruby-doc core: String)'
        expect(parse(markdown)).to eq "#{base_url}/String.html"
      end

      it 'returns the right text with link for a single class' do
        markdown = '*emphasized* (ruby-doc core: String)'
        expect(parse(markdown)).to eq "*emphasized* #{base_url}/String.html"
      end

      it 'returns the right link for a single namespaced class' do
        markdown = '(ruby-doc core: Enumerator::Lazy)'
        expect(parse(markdown)).to eq "#{base_url}/Enumerator/Lazy.html"
      end

      it 'returns the right link for a multi namespaced class' do
        markdown = '(ruby-doc core: Thread::Backtrace::Location)'
        expect(parse(markdown)).to eq "#{base_url}/Thread/Backtrace/Location.html"
      end

      it "returns the right link for a single class's class method" do
        markdown = '(ruby-doc core: String::new)'
        expect(parse(markdown)).to eq "#{base_url}/String.html#method-c-new"
      end

      it "returns the right link for a single class's instance method" do
        markdown = '(ruby-doc core: String#count)'
        expect(parse(markdown)).to eq "#{base_url}/String.html#method-i-count"
      end

      it "returns the right link for a namespaced class's class method" do
        markdown = '(ruby-doc core: Enumerator::Lazy::new)'
        expect(parse(markdown)).to eq "#{base_url}/Enumerator/Lazy.html#method-c-new"
      end

      it "returns the right link for a namespaced class's instance method" do
        markdown = '(ruby-doc core: Enumerator::Lazy#flat_map)'
        expect(parse(markdown)).to eq "#{base_url}/Enumerator/Lazy.html#method-i-flat_map"
      end

      it 'returns the right link for an instance method not starting with word characters' do
        markdown = '(ruby-doc core: Array#<<)'
        expect(parse(markdown)).to eq "#{base_url}/Array.html#method-i-3C-3C"
      end

      it 'returns the right link for an instance method with regex characters' do
        markdown = '(ruby-doc core: Array#any?)'
        expect(parse(markdown)).to eq "#{base_url}/Array.html#method-i-any-3F"
      end
    end

    context 'for a text containing a stdlib doc markup' do
      let(:base_url) { "http://ruby-doc.org/stdlib-#{RUBY_VERSION}/libdoc" }

      it 'returns the right link for a single class' do
        markdown = '(ruby-doc stdlib: Time)'
        expect(parse(markdown)).to eq "#{base_url}/time/rdoc/Time.html"
      end

      it 'returns the right text with link for a single class' do
        markdown = '*emphasized* (ruby-doc stdlib: Time)'
        expect(parse(markdown)).to eq "*emphasized* #{base_url}/time/rdoc/Time.html"
      end

      it 'returns the right link for a single class with an explicit lib' do
        markdown = '(ruby-doc stdlib: date Time)'
        expect(parse(markdown)).to eq "#{base_url}/date/rdoc/Time.html"
      end

      it 'returns the right link for a single namespaced class' do
        markdown = '(ruby-doc stdlib: Net::HTTP)'
        expect(parse(markdown)).to eq "#{base_url}/net/http/rdoc/Net/HTTP.html"
      end

      it 'returns the right link for a multi namespaced class' do
        markdown = '(ruby-doc stdlib: json JSON::Ext::Generator::State)'
        expect(parse(markdown)).to eq "#{base_url}/json/rdoc/JSON/Ext/Generator/State.html"
      end

      it "returns the right link for a single class's class method" do
        markdown = '(ruby-doc stdlib: Time::parse)'
        expect(parse(markdown)).to eq "#{base_url}/time/rdoc/Time.html#method-c-parse"
      end

      it "returns the right link for a single class's instance method" do
        markdown = '(ruby-doc stdlib: Time#httpdate)'
        expect(parse(markdown)).to eq "#{base_url}/time/rdoc/Time.html#method-i-httpdate"
      end

      it "returns the right link for a namespaced class's class method" do
        markdown = '(ruby-doc stdlib: Net::HTTP::get)'
        expect(parse(markdown)).to eq "#{base_url}/net/http/rdoc/Net/HTTP.html#method-c-get"
      end

      it "returns the right link for a namespaced class's instance method" do
        markdown = '(ruby-doc stdlib: Net::HTTP#get)'
        expect(parse(markdown)).to eq "#{base_url}/net/http/rdoc/Net/HTTP.html#method-i-get"
      end
    end
  end
end
