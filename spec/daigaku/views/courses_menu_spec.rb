require 'spec_helper'

describe Daigaku::Views::CoursesMenu, type: :view do

  it { is_expected.to respond_to :enter }
  it { is_expected.to respond_to :reenter_courses_menu }

end
