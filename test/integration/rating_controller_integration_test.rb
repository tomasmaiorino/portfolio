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

end
