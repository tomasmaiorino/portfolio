require 'test_helper'

class ClientControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {:name => 'tomas', :active => true, :token => 'xxffwf', :security_permissions => 1}
    @invalid_params_no_name = {:active => true, :token => 'xxffwf', :security_permissions => 1}
    @invalid_params_no_token = {:name => 'tomas', :active => true, :security_permissions => 1}
    @invalid_params_no_required_values = {:active => true, :security_permissions => 1}
  end

  test "should create client" do
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    assert_response :success
    #assert_response :bad_request
    message = response.body
    assert_not_nil message
  	message = JSON.parse(message)
  	assert message.has_key?("id")
    assert_not_nil message['id']
  end

  test "should return invalid client no name" do
    params = @invalid_params_no_name
    post '/api/v1/client', params

    assert_response :bad_request
    message = response.body
    assert_not_nil message
  	message = JSON.parse(message)
  	assert message.has_key?("name")
    assert_not_nil message['name']
  end

  test "should return invalid client no token" do
    params = @invalid_params_no_token
    post '/api/v1/client', params

    assert_response :bad_request
    message = response.body
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("token")
    assert_not_nil message['token']
  end

  test "should return invalid client no required values" do
    params = @invalid_params_no_required_values
    post '/api/v1/client', params

    assert_response :bad_request
    message = response.body
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("token")
    assert_not_nil message['token']
    assert message.has_key?("name")
    assert_not_nil message['name']
  end

  test "should update client" do
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    assert_response :success
    #assert_response :bad_request
    message = response.body
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("id")
    assert_not_nil message['id']
    old_id = message['id']

    params['name'] = 'New Name'

    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    assert_response :success
    #assert_response :bad_request
    assert_not_nil message
    message = JSON.parse(message)
    assert message.has_key?("id")
    assert_not_nil message['id']
    assert_equal old_id, message['id']
  end




end
