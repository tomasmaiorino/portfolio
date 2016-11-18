require 'test_helper'

class TechTagControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {:name => 'oracle'}
    @invalid_params_no_name = {'':''}
    @duplicate_name_message = {:name => ["duplicate tech"]}
  end

  test "should_create_tech_tag" do
    tech_tag = TechTag.new
    TechTag.stubs(:find_by).returns(nil)
    tech_tag = stub(:valid? => true, :name => 'Java', :id => 3)
    JSON.stubs(:parse).returns(tech_tag)
    tech_tag.expects(:save).returns(true).once

    params = @valid_params
    post '/api/v1/tech_tag', params
    JSON.unstub(:parse)
    valid_success_request(response, {'id' => ''})

  end

  test "should_not_create_tech_tag_invalid_tech_name" do
    tech_tag = TechTag.new
    TechTag.stubs(:find_by).returns(nil)
    tech_tag = stub(:valid? => false, :errors => @name_required)
    JSON.stubs(:parse).returns(tech_tag)
    tech_tag.expects(:save).never

    params = @invalid_params_no_name
    post '/api/v1/tech_tag', params
    JSON.unstub(:parse)
    message = valid_bad_request(response, {'name' => ''})

  end

  test "should_update_tech_tag" do
    params = @valid_params

    tech_tag = TechTag.new
    tech_tag = stub(:valid? => true, :name => 'New Orale', :id => 1)

    tech_tag_temp = TechTag.new
    tech_tag_temp = stub(:nil? => false, :name= => 'Orale', :id => 1)

    JSON.stubs(:parse).returns(tech_tag)

    TechTag.stubs(:find_by).returns(tech_tag_temp)
    tech_tag_temp.expects(:save).returns(true).once

    params[:id] = 1

    put "/api/v1/tech_tag", params
    JSON.unstub(:parse)
    message = valid_success_request(response, {'id' => ''})

  end

  test "should_not_update_tech_tag_not_passing_id" do
    params = @valid_params
    put "/api/v1/tech_tag", params
    message = valid_bad_request(response, {'id' => ''})

  end

  test "should_not_update_tech_tag_not_duplicate_name" do
    params = @valid_params
    tech_tag = TechTag.new
    tech_tag = stub(:valid? => false, :errors => @duplicate_name_message, :name => 'Name', :id => 3)

    JSON.stubs(:parse).returns(tech_tag)

    tech_tag.expects(:save).never
    params[:id] = 1

    put "/api/v1/tech_tag", params
    JSON.unstub(:parse)
    message = valid_bad_request(response, {'name' => 'duplicate tech'}, true)

  end

  test "should_not_find_tech_tag_by_id" do
    get "/api/v1/tech_tag/222"
    assert_response :not_found
  end

  test "should_find_tech_tag_by_id" do
    tech = TechTag.new
    tech.id = 1
    tech.name = 'Java'

    TechTag.stubs(:find).returns(tech)

    get "/api/v1/tech_tag/#{tech.id}"
    message = valid_success_request(response)
    assert_equal tech.id, message['id']
    assert_equal tech.name, message['name']

  end

  test "should_not_find_tech_tag_by_name" do
    get "/api/v1/tech_tag/sql"
    assert_response :not_found
  end

  test "should_find_tech_tag_by_name" do

    params = @valid_params
    tech = TechTag.new
    tech.id = 1
    tech.name = 'Java'

    TechTag.stubs(:find_by).returns(tech)

    get "/api/v1/tech_tag/#{tech.name}"
    message = valid_success_request(response)
    assert_equal tech.id, message['id']
    assert_equal tech.name, message['name']

  end

end
