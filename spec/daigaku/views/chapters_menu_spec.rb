require 'spec_helper'

describe Daigaku::Views::ChaptersMenu, type: :view do

  it { is_expected.to respond_to :enter_chapters_menu }
  it { is_expected.to respond_to :reenter_chapters_menu }

end
