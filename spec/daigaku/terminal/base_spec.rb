require 'spec_helper'

describe Daigaku::Terminal::Base do

  subject { Daigaku::Terminal::Base.new }

  before do
    allow($stdout).to receive(:puts) { |string| string }
    allow($stdout).to receive(:print) { |string| string }
  end

  [:say, :empty_line, :get].each do |method|
    it "has the private method #{method}" do
      expect(subject.private_methods.include?(method)).to be_truthy
    end
  end

  describe "::say" do
    it "prints the prescribed output to the $stdout" do
      line = "line"
      expect($stdout).to receive(:puts).with("\t#{line}")
      subject.send(:say, line)
    end

    it "adds the line start in case of multiline inputs" do
      lines = "first line\nsecond line\nthird line\n"
      out_lines = lines.split("\n").map {|l| "\t#{l}" }.join("\n")
      expect($stdout).to receive(:puts).with(out_lines)
      subject.send(:say, lines)
    end
  end

  describe "::empty_line" do
    it "prints an empty line to the $stdout" do
      expect($stdout).to receive(:puts).with('')
      subject.send(:empty_line)
    end
  end

  describe "::get" do
    it "prints a string to $stdout to get a line on $stdin" do
      printed = 'printed'
      received = 'received'

      allow($stdin).to receive(:gets) { received }
      expect($stdout).to receive(:print).with("\n\t#{printed}: ")
      expect($stdin).to receive(:gets)
      subject.send(:get, printed)
    end
  end

end
