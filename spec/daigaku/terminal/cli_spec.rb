require 'spec_helper'

describe Daigaku::Terminal::CLI do
  before { suppress_print_out }

  it { is_expected.to be_a Thor }
  it { is_expected.to respond_to :about }
  it { is_expected.to respond_to :welcome }
  it { is_expected.to respond_to :scaffold }
  it { is_expected.to respond_to :learn }
  it { is_expected.to respond_to :courses }
  it { is_expected.to respond_to :solutions }
  it { is_expected.to respond_to :setup }

  describe '#learn' do
    before { allow(Daigaku).to receive(:start).and_return(true) }

    context 'if there are courses' do
      before do
        allow(Daigaku::Loading::Courses).to receive(:load).and_return([1])
      end

      it 'starts the daigaku terminal app' do
        expect(Daigaku).to receive(:start)
        subject.learn
      end
    end

    context 'if there are no courses' do
      before do
        allow(Daigaku::Loading::Courses).to receive(:load).and_return([])
      end

      it 'does not start the daigaku terminal app' do
        expect(Daigaku).not_to receive(:start)
        subject.learn
      end
    end
  end

  describe '#welcome' do
    it 'runs the welcome routine' do
      allow(Daigaku::Terminal::Welcome).to receive(:run).and_return(true)
      expect(Daigaku::Terminal::Welcome).to receive(:run).once
      subject.welcome
    end
  end

  describe '#scaffold' do
    it 'runs the scaffolding' do
      allow_any_instance_of(Daigaku::Generator)
        .to receive(:scaffold)
        .and_return(true)

      expect_any_instance_of(Daigaku::Generator).to receive(:scaffold).once
      subject.scaffold
    end
  end
end
