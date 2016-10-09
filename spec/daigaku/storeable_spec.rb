require 'spec_helper'

describe Daigaku::Storeable do
  it 'responds to .key' do
    expect(Daigaku::Storeable).to respond_to :key
  end

  describe '.key' do
    it 'creates a store key from the given string' do
      key = Daigaku::Storeable.key('1-_Raw content-Title')
      expect(key).to eq 'raw_content_title'
    end

    it 'creates a cleaned up store key from a given path string' do
      key = Daigaku::Storeable.key('path/to/the/1-_Raw content string')
      expect(key).to eq 'path/to/the/raw_content_string'
    end

    it 'creates a prefixed key when a prefix option is given' do
      key = Daigaku::Storeable.key('1-_Raw content-Title', prefix: 'courses')
      expect(key).to eq 'courses/raw_content_title'
    end

    it 'creates a suffixed key if a suffix option is given' do
      key = Daigaku::Storeable.key('1-_Raw content-Title', suffix: '1-author')
      expect(key).to eq 'raw_content_title/author'
    end

    it 'creates a multi suffixed key if a suffixes option is given' do
      suffixes = ['meta', '1-author']
      title    = '1-_Raw content-Title'
      key      = Daigaku::Storeable.key(title, suffixes: suffixes)

      expect(key).to eq 'raw_content_title/meta/author'
    end
  end
end
