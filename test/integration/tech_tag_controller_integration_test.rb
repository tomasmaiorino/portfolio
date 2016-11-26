require 'test_helper'

class TechTagIntegrationControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {:name => 'oracle'}
    @invalid_params_no_name = {'':''}
    @client = get_valid_client(true)
  end

  test "integration_should_create_tech_tag" do
    params = @valid_params
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})

  end

  test "integration_should_not_create_tech_tag_invalid_tech_name" do
    params = @invalid_params_no_name
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_bad_request(response, {'name' => ''})

  end

  test "integration_should_update_tech_tag" do
    params = @valid_params
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})
    old_id = message['id']

    params[:name] = 'oracle'
    params[:id] = old_id
    add_client_token_param(params, @client)
    put "/api/v1/tech_tag", params
    message = valid_success_request(response, {'id' => ''}, true)
    assert_equal old_id, message['id']

  end

  test "integration_should_not_update_tech_tag_not_passing_id" do
    params = @valid_params
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})
    old_id = message['id']

    params[:name] = 'oracle'
    add_client_token_param(params, @client)
    put "/api/v1/tech_tag", params
    message = valid_bad_request(response, {'id' => ''})

  end

  test "integration_should_not_update_tech_tag_not_duplicate_name" do
    params = @valid_params
    #first tech
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})

    params[:name] = 'mysql'
    #second tech
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})
    old_id = message['id']

    params[:name] = 'oracle'
    params[:id] = old_id
    add_client_token_param(params, @client)
    put "/api/v1/tech_tag", params
    message = valid_bad_request(response, {'name' => 'duplicate tech'})

  end

  test "integration_should_find_tech_tag_by_id" do
    get "/api/v1/tech_tag/222"
    assert_response :not_found
  end

  test "integration_should_not_find_tech_tag_by_id" do
    TechTag.delete_all
    params = @valid_params
    #first tech
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})
    id = message['id']

    get "/api/v1/tech_tag/#{id}"
    message = valid_success_request(response)
    assert_equal id, message['id']
    assert_equal params[:name], message['name']

  end

  test "integration_should_not_find_tech_tag_by_name" do
    get "/api/v1/tech_tag/sql"
    assert_response :not_found
  end

  test "integration_should_find_tech_tag_by_name" do
    TechTag.delete_all
    params = @valid_params
    #first tech
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})
    id = message['id']

    get "/api/v1/tech_tag/#{params[:name]}"
    message = valid_success_request(response)
    assert_equal id, message['id']
    assert_equal params[:name], message['name']

  end

  test "integration_should_find_all_tech_tag" do
    TechTag.destroy_all
    tech_tags = get_valid_teck_tag(false, ['java', 'sql', 'oracle'])
    params = tech_tags[0].attributes
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})

    params = tech_tags[1].attributes
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})

    params = tech_tags[2].attributes
    add_client_token_param(params, @client)
    post '/api/v1/tech_tag', params

    message = valid_success_request(response, {'id' => ''})

    get "/api/v1/tech_tag/all"
    message = valid_success_request(response)
    assert_not_nil message
    assert_not_empty message
    assert_equal tech_tags.size, message.size
    assert_equal tech_tags[0].name, message[0]['name']
    assert_equal tech_tags[1].name, message[1]['name']
    assert_equal tech_tags[2].name, message[2]['name']    
  end

end
