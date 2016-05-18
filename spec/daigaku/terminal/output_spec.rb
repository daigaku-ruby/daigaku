require 'spec_helper'

describe Daigaku::Terminal::Output do
  subject do
    require 'thor'
    class Test < Thor
      include Daigaku::Terminal::Output
    end

    Test.new
  end

  before do
    allow($stdout).to receive(:puts) { |string| string }
    allow($stdout).to receive(:print) { |string| string }
  end

  [
    :say,
    :empty_line,
    :get,
    :say_info,
    :say_warning,
    :get_command,
    :get_confirm
  ].each do |method|
    it "has the private method #{method}" do
      expect(subject.private_methods.include?(method)).to be_truthy
    end
  end

  describe '.say' do
    it 'prints the prescribed output to the $stdout' do
      line = 'line'
      expect($stdout).to receive(:puts).with("\t#{line}")
      subject.send(:say, line)
    end

    it 'adds the line start in case of multiline inputs' do
      lines     = "first line\nsecond line\nthird line\n"
      out_lines = lines.split("\n").map { |l| "\t#{l}" }.join("\n")

      expect($stdout).to receive(:puts).with(out_lines)
      subject.send(:say, lines)
    end
  end

  describe '.empty_line' do
    it 'prints an empty line to the $stdout' do
      expect($stdout).to receive(:puts).with('')
      subject.send(:empty_line)
    end
  end

  describe '.get' do
    let(:text) { 'printed' }

    it 'prints a string to $stdout to get a line on $stdin' do
      allow($stdin).to receive(:gets).and_return('received')

      expect($stdout).to receive(:print).with("\n\t#{text} ")
      expect($stdin).to receive(:gets)
      subject.send(:get, text)
    end
  end

  describe '.say_info' do
    let(:line) { 'line' }

    it 'prints the prescribed output to the $stdout' do
      expect($stdout).to receive(:puts).exactly(4).times.with('')
      expect($stdout).to receive(:puts).with("\t" + " ℹ #{line}".light_blue)
      expect($stdout).to receive(:puts).twice.with("\t" + ('-' * 70).light_blue)
      subject.send(:say_info, line)
    end
  end

  describe '.say_warning' do
    let(:line) { 'line' }

    it 'prints the prescribed output to the $stdout' do
      expect($stdout).to receive(:puts).exactly(4).times.with('')
      expect($stdout).to receive(:puts).with("\t" + "⚠  #{line}".light_red)
      expect($stdout).to receive(:puts).twice.with("\t" + ('-' * 70).light_red)
      subject.send(:say_warning, line)
    end
  end

  describe '.get_command' do
    before do
      @correct_command = 'correct command'
      @description = 'description'
      allow($stdin).to receive(:gets).and_return(@correct_command)
      allow(Kernel).to receive(:system) { '' }
    end

    it 'prints a description' do
      expect($stdout).to receive(:puts).once.with("\t#{@description}")
      subject.send(:get_command, @correct_command, @description)
    end

    it 'gets a command from the $stdin' do
      expect($stdin).to receive(:gets)
      subject.send(:get_command, @correct_command, @description)
    end

    context 'with the right command typed in' do
      it 'gets a specified command from the user' do
        subject.send(:get_command, @correct_command, @description)
      end
    end

    context 'with a wrong command typed in' do
      it 'writes a hint' do
        wrong_command = 'wrong command'
        error = "This was something else. Try \"#{@correct_command}\"."

        allow($stdin)
          .to receive(:gets)
          .and_return(wrong_command, @correct_command)

        expect($stdout).to receive(:puts).once.with("\t#{error}")
        subject.send(:get_command, @correct_command, @description)
      end
    end
  end

  describe '.get_confirm' do
    before do
      @description = 'description'
      allow($stdin).to receive(:gets).and_return('yes')
    end

    it 'prints a warning with the given description' do
      expect(subject).to receive(:say_warning).once.with(@description)
      subject.send(:get_confirm, @description)
    end

    it 'gets a command from the $stdin' do
      expect($stdin).to receive(:gets)
      subject.send(:get_confirm, @description)
    end

    it 'takes a block to run when confirmed' do
      allow(subject).to receive(:mocked_method).and_return('mocked method')
      expect(subject).to receive(:mocked_method)
      subject.send(:get_confirm, @description) { subject.mocked_method }
    end

    it 'does not run the given block if not confirmed' do
      allow(subject).to receive(:get).and_return('no')
      expect(subject).not_to receive(:mocked_method)
      subject.send(:get_confirm, @description) { subject.mocked_method }
    end
  end
end
