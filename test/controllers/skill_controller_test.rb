require 'test_helper'

class SkillControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {:name => 'java', :points => 60}
    @invalid_params_no_name = {:points => 12}
    @invalid_params_no_token = {:name => 'tomas', :active => true, :security_permissions => 1}
    @invalid_params_no_required_values = {:active => true, :security_permissions => 1}
  end

  test "should_create_skill" do
    params = @valid_params
    post '/api/v1/skill', params
    assert_response :success

    message = response.body
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("id")
    assert_not_nil message['id']
  end

  test "should return invalid skill no name" do
    params = @invalid_params_no_name
    post '/api/v1/skill', params
    valid_bad_request(response, {'name' => ''})
  end

  test "should not create skill duplicated name" do
    params = @valid_params
    post '/api/v1/skill', params

    message = response.body
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("id")
    assert_not_nil message['id']

    response.body = nil

    params = {:name => 'java', :points => 40}
    post '/api/v1/skill', params
    valid_bad_request(response, {'name' => ''})
  end

  test "should update skill" do
    params = @valid_params
    post '/api/v1/skill', params

    message = response.body
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("id")
    assert_not_nil message['id']
    old_id = message['id']
    response.body = nil

    params = {:id => old_id, :name => 'java', :points => 40}
    post '/api/v1/skill', params

    message = response.body
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("id")
    assert_not_nil message['id']
    assert_equal old_id, message['id']
  end

end
