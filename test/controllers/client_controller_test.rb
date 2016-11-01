require 'test_helper'

class ClientControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {:name => '112211', :active => true, :token => 'teste@teste.com', :security_permissions => 1}
    @invalid_params_no_name = {:name => 'tomas', :active => true, :token => 'teste@teste.com', :security_permissions => 1}
    @invalid_params_no_token = {:name => 'tomas', :active => true, :token => 'teste@teste.com', :security_permissions => 1}
  end
  test "should create client" do
    params = @valid_params
    post '/api/v1/client', params#, {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json'}
    assert_response :success
    #assert_response :bad_request
    #message = response.body
    #assert_not_nil message
  	#message = JSON.parse(message)
  	#assert message.has_key?("message")
  	#assert message.has_key?("subject")
  	#assert message.has_key?("sender_email")
  end
end
