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
        :points => 6
    }
  end

  test "should_create_rating_without_company" do
    params = @valid_params
    client = Client.new
    Client.stubs(:find_by).returns(client)
    Rating.any_instance.stubs(:valid?).returns(true)
    Rating.any_instance.stubs(:save).returns(true)
    post '/api/v1/rating', params
    valid_success_request(response, {'id' => 1})
  end
end
