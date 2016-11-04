require 'test_helper'

class CompanyControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  @valid_params = {
    :client => {:name => 'tomas', :active => true, :token => 'xxffwf', :security_permissions => 1}
    :skill
}
end
