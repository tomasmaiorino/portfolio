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
  end

  test "should_create_skill" do
    #params = @valid_params
    #post '/api/v1/skill', params
    #message = valid_success_request(response, {'id' => ''}, true)

    skill = mock()
    JSON.stubs(:parse).returns(skill)
    Skill.stubs(:find_name).returns(nil)
    skill = stub(:valid? => true, :save => true, :id => 2, :name => 'Java')
    skill.expects(:save).at_least_once

    params = @valid_params
    post '/api/v1/skill', params
    valid_success_request(response, {'id' => ''})
  end

  test "should return invalid skill no name" do
    params = @invalid_params_no_name
    post '/api/v1/skill', params
    valid_bad_request(response, {'name' => ''})
  end

  test "should return invalid skill no required values" do
    params = @invalid_params_no_required_values
    post '/api/v1/skill', params
    valid_bad_request(response, {'name' => '', 'points' => ''})
  end

  test "should not create skill duplicated name" do
    params = @valid_params
    post '/api/v1/skill', params

    message = valid_success_request(response, {'id' => ''}, true)

    response.body = nil

    params = {:name => 'java', :points => 40}
    post '/api/v1/skill', params
    valid_bad_request(response, {'name' => 'duplicate Skill name'})
  end

# => TO FIX CASE INSENSITIVE
  test "should update skill" do
    params = @valid_params
    post '/api/v1/skill', params

    message = valid_success_request(response, {'id' => ''})
    old_id = message['id']
    response.body = nil

    params = {:id => old_id, :name => 'java', :points => 50}
    put '/api/v1/skill', params

    message = valid_success_request(response, {'id' => ''}, true)
    assert_equal params['name'], message['name']
    assert_equal old_id, message['id']
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
