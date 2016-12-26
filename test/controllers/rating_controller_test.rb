require 'test_helper'

class RatingControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @valid_params = {
        :points => 3,
        :ct => '1'
        #:cp => "http://www.cnn.com;/img.jpg",
    }
    @valid_params_with_company = {
        :points => 3,
        :cp => "rhtkeo123",
        :ct => '1'
    }
    @invalid_params = {
        :points => 6,
        :ct => '1'
    }
    @invalid_points_bigger_than_five = {:points=>["must be less than or equal to 5"]}

    @invalid_points_less_than_1 = {:points=>["must be greater than or equal to 1"]}

  end

  test "should_create_rating_without_company" do
    params = @valid_params
    client = Client.new
    Client.stubs(:find_by).returns(client)
    Rating.any_instance.stubs(:valid?).returns(true)
    Rating.any_instance.stubs(:save).returns(true)
    Rating.any_instance.stubs(:id).returns(1)
    post '/api/v1/rating', params
    valid_success_request(response, {'id' => 1})
  end

  test "should_create_rating_with_company" do
    params = @valid_params
    params[:cp] = 'tk1'
    client = Client.new
    Client.stubs(:find_by).returns(client)
    company = Company.new
    Company.stubs(:find_by).returns(company)
    Rating.any_instance.stubs(:valid?).returns(true)
    Rating.any_instance.stubs(:save).returns(true)
    Rating.any_instance.stubs(:id).returns(1)
    post '/api/v1/rating', params
    valid_success_request(response, {'id' => 1})
  end

  test "should_not_create_rating" do
    rating = Rating.new
    rating.stubs(:errors).returns(@invalid_points_bigger_than_five)
    rating.stubs(:valid?).returns(false)

    JSON.stubs(:parse).returns(rating)
    Client.stubs(:find_by).returns(Client.new)
    params = @invalid_params
    post '/api/v1/rating', params
    JSON.unstub(:parse)
    rating.expects(:save).returns(true).never
    message = valid_bad_request(response, {'points' =>'must be less than or equal to 5'})
  end

  test "should_not_create_not_informing_client_token" do
    params = @valid_params
    post '/api/v1/rating', params
    message = valid_unauthorized(response)
  end


  test "should_not_create_rating_points_less_than_one" do
    rating = Rating.new
    rating.stubs(:errors).returns(@invalid_points_less_than_1)
    rating.stubs(:valid?).returns(false)

    JSON.stubs(:parse).returns(rating)
    Client.stubs(:find_by).returns(Client.new)
    params = @invalid_params
    post '/api/v1/rating', params
    JSON.unstub(:parse)
    rating.expects(:save).returns(true).never
    message = valid_bad_request(response, {'points' =>'must be greater than or equal to 1'})
  end


end
