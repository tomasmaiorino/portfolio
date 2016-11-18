require 'test_helper'

class ClientControllerIntegrationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {:name => 'tomas', :active => true, :token => 'xxffwf', :security_permissions => 1}
    @invalid_params_no_name = {:active => true, :token => 'xxffwf', :security_permissions => 1}
    @invalid_params_no_token = {:name => 'tomas', :active => true, :security_permissions => 1}
    @invalid_params_no_required_values = {:active => true, :security_permissions => 1}
  end

  test "integration_should create client" do
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

    message = valid_success_request(response, {'id' => ''})

  end

  test "integration_should return invalid client no name" do
    params = @invalid_params_no_name
    post '/api/v1/client', params

    valid_bad_request(response, {'name' => ''})

  end

  test "integration_should return invalid client no token" do
    params = @invalid_params_no_token
    post '/api/v1/client', params

    valid_bad_request(response, {'token' => ''})
  end

  test "integration_should return invalid client no required values" do
    params = @invalid_params_no_required_values
    post '/api/v1/client', params

    valid_bad_request(response, {'token' => '', 'name' => ''})
end

  test "integration_should update client" do
    Client.delete_all
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

    message = valid_success_request(response, {'id' => ''})

    old_id = message['id']

    params = {:id => old_id, :name => 'tomas updated', :active => true, :token => 'xxffwf', :security_permissions => 1}

    response.body = nil
    message = nil

    put '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

    message = valid_success_request(response, {'id' => ''})
    assert_equal old_id, message['id']
  end

  test "integration_should not update client not passing id" do
    Client.delete_all
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    valid_success_request(response, {'id' => ''})

    params = {:name => 'tomas new', :active => true, :token => 'xxffwf', :security_permissions => 1}
    response.body = nil
    message = nil
    put '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

    #valid_bad_request(response, {'token' => 'duplicate token'})
    valid_bad_request(response, {'id' => 'Field required'})

  end

  test "integration_should not update client passing duplicate token" do
    Client.delete_all
    #creating first client
    params = @valid_params
    params[:id] = 332
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    valid_success_request(response, {'id' => ''}, true)

    response.body = nil
    message = nil
    #second user
    params = {:name => 'tomas new', :active => true, :token => 'xxffwf2', :security_permissions => 1}
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

    message = valid_success_request(response, {'id' => ''})

    params = {:id => message['id'], :name => 'tomas updated', :active => true, :token => 'xxffwf', :security_permissions => 1}
    put '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}

    valid_bad_request(response, {'token' => 'duplicate token'})

  end

  test "should_find_client_by_id" do
    Client.delete_all
    #creating first client
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    message = valid_success_request(response, {'id' => ''}, true)
    old_id = message['id']
    message = nil
    response.body = nil

    get "/api/v1/client/#{old_id}"
    message = valid_success_request(response)
    assert_equal old_id, message['id']
    assert_equal params[:token], message['token']
    assert_equal params[:name], message['name']
    assert_equal params[:active], message['active']
    assert_equal params[:security_permissions], message['security_permissions']
  end

  test "should_not_find_client_by_id" do
    get "/api/v1/client/xx11"
    assert_response :not_found
  end

end
