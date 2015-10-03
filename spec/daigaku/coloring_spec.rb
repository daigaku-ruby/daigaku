require 'spec_helper'

describe Daigaku::Coloring do

  subject do
    class Example
      include Daigaku::Coloring
    end

    Example.new
  end

  it 'has the protected method #init_colors' do
    expect(subject.protected_methods).to include :init_colors
  end

  [
    :COLOR_TEXT,
    :COLOR_TEXT_EMPHASIZE,
    :COLOR_HEADING,
    :COLOR_RED,
    :COLOR_GREEN,
    :COLOR_YELLOW,
    :BACKGROUND,
    :FONT,
    :FONT_HEADING,
    :FONT_EMPHASIZE,
    :RED,
    :GREEN,
    :YELLOW
  ].each do |const|
    it "has the constant #{const}" do
      expect(Example.const_defined?(const)).to be true
    end
  end
end
