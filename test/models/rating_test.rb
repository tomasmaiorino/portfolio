require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
=begin
  test "should not save rating" do
    rating = Rating.new
    rating.points = 0
    assert !rating.valid?

    rating.points = -1
    assert !rating.valid?

    rating.points = 6
    assert !rating.valid?
  end

  test "should create rating without company" do
    #client = get_valid_client(false)
    #company = get_valid_company(false, client)
    rating = Rating.new
    rating.points = 3
    assert rating.valid?
    puts rating.errors.message
    assert rating.save
  end
=end
end
