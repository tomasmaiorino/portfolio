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
    @name_required = {:name => ["Field Required"]}
    @token_required = {:token => ["Field Required"]}
    @token_duplicate = {:token => ["duplicate token"]}
    @name_token_required = {:token => ["Field Required"], :name => ["Field Required"]}
  end

  test "should create client" do
    #mocks
    client_id = 3
    client = Client.new
    client = stub(:valid? => true,
      :name => "Monsters", :token => 'tk12', :active => true, :id => client_id, :save => true)
    client.expects(:save).returns(true).once
    Client.stubs(:find_by).returns(nil)
    JSON.stubs(:parse).returns(client)
    #call
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    JSON.unstub(:parse)
    #checks
    message = valid_success_request(response, {'id' => client_id})

  end

  test "should return invalid client no name" do
    #mocks
    client = Client.new
    client = stub(:valid? => false, :errors => @name_required, :name => '')
    JSON.stubs(:parse).returns(client)
    client.expects(:save).returns(true).never
    #call
    params = @invalid_params_no_name
    post '/api/v1/client', params
    JSON.unstub(:parse)
    #checks
    valid_bad_request(response, {'name' => ''})

  end

  test "should return invalid client no token" do
    #mocks
    client = Client.new
    client = stub(:valid? => false, :errors => @token_required)
    JSON.stubs(:parse).returns(client)
    client.expects(:save).returns(true). never
    #call
    params = @invalid_params_no_token
    post '/api/v1/client', params
    JSON.unstub(:parse)
    #checks
    valid_bad_request(response, {'token' => ''})
  end

  test "should return invalid client no required values" do
    client = Client.new
    client = stub(:valid? => false, :errors => @name_token_required)
    JSON.stubs(:parse).returns(client)
    client.expects(:save).returns(true).never
    #call
    params = @invalid_params_no_required_values
    post '/api/v1/client', params
    JSON.unstub(:parse)
    #checks
    valid_bad_request(response, {'token' => '', 'name' => ''})
end

  test "should update client" do
    client = Client.new
    client = stub(:valid? => true,
            :name => 'Monsters',
            :token => 'tk12',
            :active => 1,
            :security_permissions => 0,
            :id => 2)

    JSON.stubs(:parse).returns(client)

    client_temp = Skill.new
    client_temp = stub(:nil? => false,
        :name= => 'Monsters Update',
        :token= => 'tk12',
        :active= => 1,
        :security_permissions= => 0,
        :id => 2)

    Client.stubs(:find_by).returns(client_temp)
    client_temp.expects(:save).returns(true).once

    params = @valid_params
    params[:id] = 2
    put '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    JSON.unstub(:parse)

    message = valid_success_request(response, {'id' => ''})
  end

  test "should not update client not passing id" do
    params = @valid_params
    put '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    valid_bad_request(response, {'id' => 'Field required'})
  end

  test "should not update client passing duplicate token" do
    params = @valid_params
    client = Client.new
    client = stub(:valid? => false,
            :name => 'Monsters',
            :token => 'tk12',
            :active => 1,
            :security_permissions => 0,
            :id => 2,
            :errors => @token_duplicate)

    JSON.stubs(:parse).returns(client)
    params[:id] = 2
    put '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    JSON.unstub(:parse)
    valid_bad_request(response, {'token' => 'duplicate token'})

  end

  test "should_find_client_by_id" do
    #mocks
    client = Client.new
    client.id = 2
    client.name = "Monsters"
    client.token = 'tk12'
    client.active = true
    client.security_permissions = 1
    Client.stubs(:find).returns(client)
    #call
    get "/api/v1/client/#{client.id}"
    #checks
    message = valid_success_request(response)
    assert_equal client.id, message['id']
    assert_equal client.token, message['token']
    assert_equal client.name, message['name']
    assert_equal client.active, message['active']
    assert_equal client.security_permissions, message['security_permissions']
  end

  test "should_not_find_client_by_id" do
    get "/api/v1/client/xx11"
    assert_response :not_found
  end

end
