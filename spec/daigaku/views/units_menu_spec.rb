require 'spec_helper'

describe Daigaku::Views::UnitsMenu, type: :view do

  it { is_expected.to respond_to :enter_units_menu }
  it { is_expected.to respond_to :reenter_units_menu }

end
