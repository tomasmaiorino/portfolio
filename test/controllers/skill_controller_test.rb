require 'test_helper'

class SkillControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {:name => 'java', :points => 60}
    @invalid_params_no_name = {:points => 12}
    @invalid_params_no_token = {:name => 'tomas', :active => true, :security_permissions => 1}
    @invalid_params_no_required_values = {'':''}
    @name_required = {:name => ["Field Required"]}
    @name_points_required = {:name => ["Field Required"], :points => ["Field Required"] }
    @project_date_required = {:project_date => ["Field Required"]}
    @summary_required = {:summary => ["Field Required"]}
    @duplicate_name_message = {:name => ["duplicate Skill name"]}
  end

  test "should_create_skill" do
    skill = Skill.new
    skill.name = 'Java'
    skill.points = 'Java'
    Skill.stubs(:find_by).returns(nil)
    skill = stub(:valid? => true, :name => 'Java', :id => 1)
    JSON.stubs(:parse).returns(skill)
    skill.expects(:save).returns(true).once

    params = @valid_params
    post '/api/v1/skill', params
    JSON.unstub(:parse)
    valid_success_request(response, {'id' => ''})
  end

  # => TO FIX CASE INSENSITIVE
    test "should update skill" do
      skill = Skill.new
      skill = stub(:valid? => true, :id => 2,
        :name => "Java New", :points => 3)

      JSON.stubs(:parse).returns(skill)

      skill_temp = Skill.new
      skill_temp = stub(:nil? => false, :name= => 'Old Java', :points= => 3, :id => 2)

      Skill.stubs(:find_by).returns(skill_temp)
      skill_temp.expects(:save).returns(true).once

      params = @valid_params
      params[:id] = 2
      put '/api/v1/skill', params
      JSON.unstub(:parse)

      message = valid_success_request(response, {'id' => ''})

    end

  test "should return invalid skill no name" do
    skill = Skill.new
    skill = stub(:valid? => false, :name => '', :errors => @name_required)
    JSON.stubs(:parse).returns(skill)

    params = @invalid_params_no_name
    post '/api/v1/skill', params
    JSON.unstub(:parse)
    valid_bad_request(response, {'name' => ''})
  end

  test "should return invalid skill no required values" do
    params = @invalid_params_no_required_values
    post '/api/v1/skill', params
    valid_bad_request(response, {'name' => '', 'points' => ''})
  end

  test "should not create skill duplicated name" do
    skill = Skill.new
    skill = stub(:valid? => false, :name => 'Java', :errors => @duplicate_name_message)

    JSON.stubs(:parse).returns(skill)

    params = @valid_params
    post '/api/v1/skill', params
    JSON.unstub(:parse)
    valid_bad_request(response, {'name' => 'duplicate Skill name'})

  end

  test "should update skill not passing id" do
    params = @valid_params
    put '/api/v1/skill', params

    valid_bad_request(response, {'id' => 'Field required'})

  end

  test "should update skill not passing duplicate name" do
    skill = Skill.new
    skill = stub(:valid? => false, :name => 'Java',
                          :errors => @duplicate_name_message, :id => 2)
    JSON.stubs(:parse).returns(skill)

    params = @valid_params
    params[:id] = 2
    put '/api/v1/skill', params
    JSON.unstub(:parse)
    valid_bad_request(response, {'name' => 'duplicate Skill name'})

  end

  test "should_find_skill_by_id" do
    skill_id = 3
    skill_name = 'Java'
    skill_points = 43

    skill = Skill.new
    skill.id = skill_id
    skill.name = skill_name
    skill.points = skill_points

    Skill.stubs(:find).returns(skill)

    get "/api/v1/skill/#{skill_id}"

    message = valid_success_request(response)

    assert_equal skill_name, message['name']
    assert_equal skill_points, message['points']
  end

  test "should_not_find_skill_by_id" do
    get '/api/v1/skill/44'
    assert_response :not_found
  end

  test "should_not_find_skill_by_name" do
    get '/api/v1/skill/mongooioijoi'
    assert_response :not_found
  end

  test "should_find_skill_by_name" do

    skill_id = 3
    skill_name = 'Java'
    skill_points = 43

    skill = Skill.new
    skill.id = skill_id
    skill.name = skill_name
    skill.points = skill_points

    Skill.stubs(:find_by).returns(skill)

    get "/api/v1/skill/#{skill_name}"

    message = valid_success_request(response)
    assert_equal skill_name, message['name']
    assert_equal skill_points, message['points']
  end

end
