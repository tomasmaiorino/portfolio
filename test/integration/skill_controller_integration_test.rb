require 'test_helper'

class SkillControllerIntegrationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
      @valid_params = {:name => 'java', :level => 60}
      @invalid_params_no_name = {:level => 12}
      @invalid_params_no_token = {:name => 'tomas', :active => true, :security_permissions => 1}
      @invalid_params_no_required_values = {'':''}
      @client = get_valid_client(true)
    end

    test "integration_should_create_skill" do
      params = @valid_params
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      message = valid_success_request(response, {'id' => ''}, true)

    end

    test "integration_should return invalid skill no name" do
      params = @invalid_params_no_name
      add_client_token_param(params, @client)
      post '/api/v1/skill', params
      valid_bad_request(response, {'name' => ''})
    end

    test "integration_should return invalid skill no required values" do
      params = @invalid_params_no_required_values
      add_client_token_param(params, @client)
      post '/api/v1/skill', params
      valid_bad_request(response, {'name' => '', 'level' => ''})
    end

    test "integration_should not create skill duplicated name" do
      params = @valid_params
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      message = valid_success_request(response, {'id' => ''}, true)

      response.body = nil

      params = {:name => 'java', :level => 40}
      add_client_token_param(params, @client)
      post '/api/v1/skill', params
      valid_bad_request(response, {'name' => 'duplicate Skill name'})
    end

  # => TO FIX CASE INSENSITIVE
    test "integration_should update skill" do
      params = @valid_params
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      message = valid_success_request(response, {'id' => ''})
      old_id = message['id']
      response.body = nil

      params = {:id => old_id, :name => 'java', :level => 50}
      add_client_token_param(params, @client)
      put '/api/v1/skill', params

      message = valid_success_request(response, {'id' => ''}, true)
      assert_equal params['name'], message['name']
      assert_equal old_id, message['id']
    end

    test "integration_should update skill not passing id" do
      params = @valid_params
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      valid_success_request(response, {'id' => ''})
      response.body = nil
      add_client_token_param(params, @client)
      params = {:name => 'java', :level => 50}
      add_client_token_param(params, @client)
      put '/api/v1/skill', params

      valid_bad_request(response, {'id' => 'Field required'})

    end

    test "integration_should update skill not passing duplicate name" do
      params = @valid_params
      #first user
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      valid_success_request(response, {'id' => ''})
      response.body = nil

      params = {:name => 'sql', :level => 50}
      #second user
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      message = valid_success_request(response, {'id' => ''})
      old_id = message['id']

      params = {:id => old_id, :name => 'java', :level => 50}
      add_client_token_param(params, @client)
      put '/api/v1/skill', params

      valid_bad_request(response, {'name' => 'duplicate Skill name'})

    end

    test "integration_should_find_skill_by_id" do
      params = @valid_params
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      message = valid_success_request(response, {'id' => ''})
      old_id = message['id']

      get "/api/v1/skill/#{old_id}"

      message = valid_success_request(response, {'id' => ''})
      assert_equal old_id, message['id']
      assert_equal params[:name], message['name']
      assert_equal params[:level], message['level']
    end

    test "integration_should_not_find_skill_by_id" do
      get '/api/v1/skill/44'
      assert_response :not_found
    end

    test "integration_should_not_find_skill_by_name" do
      Skill.delete_all
      get '/api/v1/skill/mongooioijoi'
      assert_response :not_found
    end

    test "integration_should_find_skill_by_name" do
      params = @valid_params
      add_client_token_param(params, @client)
      post '/api/v1/skill', params

      message = valid_success_request(response, {'id' => ''})
      old_id = message['id']

      get "/api/v1/skill/#{params[:name]}"

      message = valid_success_request(response, {'id' => ''})
      assert_equal old_id, message['id']
      assert_equal params[:name], message['name']
      assert_equal params[:level], message['level']
    end
end
