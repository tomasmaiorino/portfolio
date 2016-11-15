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
    skill = mock()
    Skill.stubs(:find_name).returns(nil)
    skill = stub(:valid? => true, :id => 2, :name => 'Java')
    JSON.stubs(:parse).returns(skill)
    skill.expects(:save).returns(true).at_least_once

    params = @valid_params
    post '/api/v1/skill', params
    JSON.unstub(:parse)
    valid_success_request(response, {'id' => ''})
  end

  test "should return invalid skill no name" do
    skill = mock()
    Skill.stubs(:find_name).returns(nil)
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
    skill = mock()
    Skill.stubs(:find_name).returns(Skill.new)
    skill = stub(:valid? => false, :name => 'Java', :errors => @duplicate_name_message)
    JSON.stubs(:parse).returns(skill)

    params = @valid_params
    post '/api/v1/skill', params
    JSON.unstub(:parse)
    valid_bad_request(response, {'name' => 'duplicate Skill name'})

  end

# => TO FIX CASE INSENSITIVE
  test "should update skill" do
    skill = Skill.new
    skill.stubs(:name).returns('Java')
    skill.stubs(:points).returns(20)
    skill = stub(:valid? => true)
    #skill.expects(:save).returns(true).once
    JSON.stubs(:parse).returns(skill)
    puts 'name '
    puts skill.name
    skill_temp = Skill.new
    skill_temp.stubs(:name).returns('Java Old')
    skill_temp.stubs(:points).returns(20)
    skill_temp.stubs(:id).returns(32)
    skill_temp = stub(:nil? => true)

    Skill.stubs(:find_by).returns(skill_temp)
    #skill_temp = stub(:id => 2, :nil?   false, :name => 'Java Old', :points => 3)

    params = @valid_params
    params[:id] = 2
    put '/api/v1/skill', params
    JSON.unstub(:parse)

    message = valid_success_request(response, {'id' => ''}, true)

  end

  test "should update skill not passing id" do
    params = @valid_params
    post '/api/v1/skill', params

    valid_success_request(response, {'id' => ''})
    response.body = nil

    params = {:name => 'java', :points => 50}
    put '/api/v1/skill', params

    valid_bad_request(response, {'id' => 'Field required'})

  end

  test "should update skill not passing duplicate name" do
    params = @valid_params
    #first user
    post '/api/v1/skill', params

    valid_success_request(response, {'id' => ''})
    response.body = nil

    params = {:name => 'sql', :points => 50}
    #second user
    post '/api/v1/skill', params

    message = valid_success_request(response, {'id' => ''})
    old_id = message['id']

    params = {:id => old_id, :name => 'java', :points => 50}
    put '/api/v1/skill', params

    valid_bad_request(response, {'name' => 'duplicate Skill name'})

  end

  test "should_find_skill_by_id" do
    params = @valid_params
    post '/api/v1/skill', params

    message = valid_success_request(response, {'id' => ''})
    old_id = message['id']

    get "/api/v1/skill/#{old_id}"

    message = valid_success_request(response, {'id' => ''})
    assert_equal old_id, message['id']
    assert_equal params[:name], message['name']
    assert_equal params[:points], message['points']
  end

  test "should_not_find_skill_by_id" do
    get '/api/v1/skill/44'
    assert_response :not_found
  end

  test "should_not_find_skill_by_name" do
    Skill.delete_all
    get '/api/v1/skill/mongooioijoi'
    assert_response :not_found
  end

  test "should_find_skill_by_name" do
    params = @valid_params
    post '/api/v1/skill', params

    message = valid_success_request(response, {'id' => ''})
    old_id = message['id']

    get "/api/v1/skill/#{params[:name]}"

    message = valid_success_request(response, {'id' => ''})
    assert_equal old_id, message['id']
    assert_equal params[:name], message['name']
    assert_equal params[:points], message['points']
  end


end
