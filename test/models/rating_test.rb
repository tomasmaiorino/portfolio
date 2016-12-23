require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not create rating" do
    rating = Rating.new
    rating.points = 0
    assert !rating.valid?

    rating.points = -1
    assert !rating.valid?

    rating.points = 6
    assert !rating.valid?
  end

  test "should not create with rating" do
    rating = Rating.new
    client = get_valid_client(false)
    company = get_valid_company(false, client)
    rating.company = company
    rating.points = 0
    assert !rating.valid?
    assert !rating.save

    rating.points = -1
    assert !rating.valid?
    assert !rating.save

    rating.points = 6
    assert !rating.valid?
    assert !rating.save

  end

  test "should create rating without company" do
    rating = Rating.new
    rating.points = 3
    assert rating.valid?
    assert rating.save
  end

  test "should create rating withcompany" do
    client = get_valid_client(false)
    company = get_valid_company(false, client)
    rating = Rating.new
    rating.company = company
    rating.points = 3
    assert rating.valid?
    assert rating.save
  end

  test "should recover rating by company" do
    client = get_valid_client(false)
    company = get_valid_company(false, client)
    rating = Rating.new
    rating.company = company
    rating.points = 3
    assert rating.valid?
    assert rating.save


    rating = Rating.new
    rating.company = company
    rating.points = 5
    assert rating.valid?
    assert rating.save

    rating_temp = Rating.where(:company => company.id).all
    assert_not_nil rating_temp
    assert 1, rating_temp.length
=begin
    rating_temp = Rating.where(:company => company.id).all
    assert_not_nil rating_temp
    assert_not_empty rating_temp
    assert company.id, rating_temp[0].company.id
=end

  end


end
