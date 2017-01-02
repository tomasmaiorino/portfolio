require 'test_helper'

class RatingControllerIntegrationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
      @valid_params = {:points => 1}
      @valid_params_with_company = {:points => 1}
      @invalid_params_no_required_values = {'':''}
      @client = get_valid_client(true)
    end

    test "integration_should_create_rating_without_company" do
      params = @valid_params
      add_client_token_param(params, @client)
      post '/api/v1/rating', params

      message = valid_success_request(response, {'id' => ''}, true)

    end

    test "integration_should_create_rating_with_company" do
      company = get_valid_company(true, @client)

      params = @valid_params
      params['cp'] = company.token
      add_client_token_param(params, @client)
      post '/api/v1/rating', params

      message = valid_success_request(response, {'id' => ''}, true)

    end

    test "integration_should_create_rating_with_company_and_comments" do
      company = get_valid_company(true, @client)

      params = @valid_params
      params['cp'] = company.token
      params['comments'] = 'This site is cool'
      add_client_token_param(params, @client)
      post '/api/v1/rating', params

      message = valid_success_request(response, {'id' => ''}, true)

    end

    test "integration_should_recover_rating_by_company" do
      company = get_valid_company(true, @client)

      params = @valid_params
      params['cp'] = company.token
      add_client_token_param(params, @client)
      post '/api/v1/rating', params

      message = valid_success_request(response, {'id' => ''})

      params = @valid_params
      params['points'] = 2
      add_client_token_param(params, @client)
      post '/api/v1/rating', params

      message = valid_success_request(response, {'id' => ''})

      params = @valid_params
      params['points'] = 5
      add_client_token_param(params, @client)
      post '/api/v1/rating', params

      message = valid_success_request(response, {'id' => ''})

      get '/api/v1/rating/' << company.token

      rating_get = valid_success_request(response)
      assert_not_nil rating_get
      assert_not_empty rating_get
      assert_equal 3, rating_get.length
      assert rating_get.to_a.index{|x| x['points'] == 5} > 0
      assert_nil rating_get.to_a.index{|x| x['points'] == 4}
    end

    test "integration_should_recover_rating_with_comments_by_company" do
      Company.delete_all
      Rating.delete_all
      company = get_valid_company(true, @client)
      comments = 'This site is cool'

      params = @valid_params
      params['cp'] = company.token
      params['comments'] = comments

      add_client_token_param(params, @client)
      post '/api/v1/rating', params

      message = valid_success_request(response, {'id' => ''})

      get '/api/v1/rating/' << company.token

      rating_get = valid_success_request(response)
      assert_not_nil rating_get
      assert_not_empty rating_get
      assert_equal 1, rating_get.length
      assert_equal comments, rating_get[0]['comments']
      assert_nil rating_get[0]['created_at']
      assert_nil rating_get[0]['updated_at']
      assert_nil rating_get[0]['company']
    end

    test "integration_should_not_recover_rating_by_company" do      
      get '/api/v1/rating/' << 'tk'
      assert_response :not_found

    end

end
