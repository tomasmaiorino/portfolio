require 'test_helper'

class CompanyControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @skills = ['sql', 'java', 'oracle']
    @client = {:client_id => '321'}
    @client_invalid = {:name => 'tomas', :active => true}
    @client_broken = {:temp => 'tomas', :active => true}
    @valid_params = {
      :name => 'tomas',
      :token => 'xxffwf',
      :client_id => @client,
      #:client => @client,
      :skills => @skills
    }
  end

  test "should_create_company_without_skills" do
    client = get_valid_client(true)
    params = @valid_params
    params[:client_id] = client.id
    @valid_params[:client_id] = client.id

    Client.expects(:find).with(client.id).returns(client)
    Client.unstub(:find)
    post '/api/v1/company', params
    print_response(response)
    message = valid_success_request(response, {'id' => ''})
  end

  test "should_create_company_with_skills" do
    client = Client.new
    client.id = 553323
    params = @valid_params
    params[:client_id] = client.id
    Client.stubs(:find).returns(client)
    Client.any_instance.stubs(:find).returns(client)
    skills = get_valid_skill(true, -1, @skills)
    @valid_params[:skills] = skills
    post '/api/v1/company', params
    print_response(response)
    message = valid_success_request(response, {'id' => ''})
  end

  test "should_return_nil_skills" do
    company_controlle = CompanyController.new
    assert_nil company_controlle.configure_skills(nil)
    company = {}
    assert_nil company_controlle.configure_skills(company)
    company = {:client_id => 33322}
    assert_nil company_controlle.configure_skills(company)
  end

  test "should_return_skills" do
    skills = get_valid_skill(false, -1, @skills)
    params = @valid_params
    Skill.stubs(:load_skills).returns(skills)
    company_controlle = CompanyController.new
    company = {:skills => @skills}
    skills_temp = company_controlle.configure_skills(company)
    assert_not_nil skills_temp
    assert_not_empty skills_temp
    assert_equal skills.size, skills_temp.size
    assert_equal skills[0].name, skills_temp[0].name
  end

  test "should_find_company_by_token" do
    company_temp = get_valid_company(false)
    client = get_valid_client(false)
    skills = get_valid_skill(false, -1, @skills)

    company_temp.client = client
    company_temp.skills = skills

    Company.stubs(:find_by).returns(company_temp)

    get "/api/v1/company/#{company_temp.token}"
    message = valid_success_request(response)
    assert_equal company_temp.id, message["id"]
    assert_equal company_temp.name, message["name"]
    assert_equal skills.size, message["skills"].size
    assert_equal skills[0].name, message["skills"][0]['name']
    assert_equal skills[0].points, message["skills"][0]['points']
    assert_equal skills[1].name, message["skills"][1]['name']
    assert_equal skills[1].points, message["skills"][1]['points']
    assert_equal skills[2].name, message["skills"][2]['name']
    assert_equal skills[2].points, message["skills"][2]['points']
  end

  test "should_find_company_by_token_not_found" do
    get "/api/v1/company/33"
    assert_response :not_found
  end


end
