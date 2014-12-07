require 'spec_helper'

describe Daigaku::Solution do
  it { should respond_to :code }
  it { should respond_to :path }
  it { should respond_to :verify! }
  it { should respond_to :verified? }
  it { should respond_to :errors }
end