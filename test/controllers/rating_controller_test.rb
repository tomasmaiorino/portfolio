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

  test "should_return_all_ratings" do
    ratings = get_valid_rating(false, 10)

    Rating.stubs(:all).returns(ratings)
    get '/api/v1/rating'  
    message = valid_success_request(response)

    assert_not_nil message['average']
    assert_not_nil message['ratings']
    assert_not_empty message['ratings']
    assert_equal 10, message['ratings'].size
  end

  test "should_get_ratings_average_return_nil_using_nil_array" do
    rating_controller = RatingController.new
    assert_nil rating_controller.get_ratings_average

    assert_nil rating_controller.get_ratings_average(nil)
  end

  test "should_get_ratings_average_return_nil_using_empty_array" do
    rating_controller = RatingController.new
    ratings = []
    assert_equal 0, rating_controller.get_ratings_average(ratings)
  end

  test "should_get_ratings_average" do
    rating_controller = RatingController.new
    ratings = get_valid_rating(false, 100)
    total = 0
    ratings.each{|s|
      total = total + s.points
    }
    average = rating_controller.get_ratings_average(ratings)
    assert_not_nil average
    assert_equal total / ratings.size, average
  end

  test "should_get_ratings_average_zero" do
    rating_controller = RatingController.new
    ratings = get_valid_rating(false)
    ratings.points = 0

    average = rating_controller.get_ratings_average([ratings])
    assert_not_nil average
    assert_equal 0, average
  end

end
