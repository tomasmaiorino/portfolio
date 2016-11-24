require 'test_helper'

class CompanyControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @skills = ['sql', 'java', 'oracle']
    @client_id = 323
    @client_invalid = {:name => 'tomas', :active => true}
    @client_broken = {:temp => 'tomas', :active => true}
    @duplicate_token_message = {:token=>["duplicate token"]}
    @valid_params = {
      :name => 'tomas',
      :token => 'xxffwf',
      :manager_name => 'manager',
      :main_color => '#FF00FF',
      :client_id => @client_id
    }
    @invalid_params_no_name = {
      :token => 'xxffwf',
      :client_id => @client_id
    }
    @invalid_params_no_token = {
      :token => '',
      :name => 'monster',
      :client_id => @client_id
    }

    @name_required = {:name => ["Field Required"]}
    @token_required = {:token => ["Field Required"]}

    @project = {
        :name => "Monsters",
        :img => "http://www.cnn.com;/img.jpg",
        :link_img => "http://www.cnn.com",
        :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
        :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        :improvements => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
        :time_spent => "2 weeks",
        :active => true,
        :future_project => false,
        :project_date => 1,
        :id => 1
    }
    @project_1 = {
        :name => "Lab",
        :img => "http://www.cnn.com;/img.jpg",
        :link_img => "http://www.cnn.com",
        :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
        :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        :improvements => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
        :time_spent => "2 weeks",
        :active => true,
        :future_project => true,
        :project_date => 1,
        :id => 2
    }
    @tech_tag = {:name => 'ORACLE'}
    @tech_tag_1 = {:name => 'JAVA'}

    client = Client.new
    Client.stubs(:find_by).returns(client)
    #Client.find_by(:token => @json['token'])
  end

#
# => CREATE BLOCK
#
  test "should_create_company_without_skills" do

    client = get_valid_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:name= => 'Lab',
          :token= => 'tk12', :main_color => '#FF00FF', :main_color= => '#FF00FF',
          :manager_name= => 'manager name',
          :email= => 'manager@company.com',
          :active= => true,
          :client= => client, :token => 'tk12', :id => 1, :skills => nil, :id= => 1)

    company.stubs(:save).returns(true).once
    company.stubs(:valid?).returns(true)
    Company.stubs(:new).returns(company)
    Company.stubs(:find_by).returns(nil)

    params = @valid_params
    params[:client_id] = client.id
    params[:client_id] = client.id

    add_client_token_param(params, client)

    #controller.request.host = Rails.application.config.test_host
    #host! Rails.application.config.test_host
    post '/api/v1/company', params
    print_response(response)
    message = valid_success_request(response, {'id' => ''})
  end

  test "should_not_create_company_without_name" do

    client = get_valid_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:token= => 'tk12', :name= => '',
          :main_color= => '#FF00FF',
          :manager_name= => 'manager name',
          :email= => 'manager@company.com',
          :active= => true,
          :client= => client, :id= => 1, :errors => @name_required, :skills => nil)

    company.stubs(:valid?).returns(false)
    Company.stubs(:new).returns(company)

    params = @invalid_params_no_name
    params[:client_id] = client.id
    add_client_token_param(params, client)
    post '/api/v1/company', params
    valid_bad_request(response, {'name' => ''})
  end

  test "should_not_create_company_without_token" do

    client = get_valid_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:token= => 'tk12',
          :name= => '',
          :main_color= => '#FF00FF',
          :email= => 'manager@company.com',
          :manager_name= => 'manager name',
          :active= => true,
          :client= => client,
          :token => '',
          :id => 1, :id= => 1, :errors => @token_required, :skills => nil)

    company.stubs(:valid?).returns(false)
    Company.stubs(:new).returns(company)

    params = @invalid_params_no_token
    params[:client_id] = client.id
    add_client_token_param(params, client)
    #@request.host = TestCase.TEST_REQUEST_HOST
    post '/api/v1/company', params
    valid_bad_request(response, {'token' => ''})
  end

  test "should_not_create_company_invalid_client" do
    client = get_valid_mock_client
    Client.stubs(:find_by).returns(client)
    Client.stubs(:find).raises(ActiveRecord::RecordNotFound)

    params = @valid_params
    params[:client_id] = client.id
    params = @valid_params
    add_client_token_param(params, client)
    post '/api/v1/company', params
    valid_bad_request(response, {'client_id' => ''})
  end

  test "should_create_company_with_skills" do
    client = get_valid_mock_client
    Client.stubs(:find).returns(client)

    skills = get_valid_skill(false, -1, @skills)
    skills.each_with_index{|s,i|
      s.id = i
    }

    Skill.stubs(:load_skills).returns(skills)

    company = Company.new
    company = stub(:name= => 'Lab',
          :token= => 'tk12',
          :token => 'tk12',
          :client= => client,
          :id= => 1, :id => 1,
          :manager_name= => 'manager name',
          :email= => 'manager@company.com',
          :main_color= => '#FF00FF',
          :active= => true,
          :valid? => true, :nil? => false, :skills= => skills, :skills => skills)
    company.stubs(:save).returns(true).once

    Company.stubs(:new).returns(company)
    Company.stubs(:find_by).returns(nil)

    params = @valid_params
    params[:client_id] = client.id
    params[:skills] = @skills
    add_client_token_param(params, client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
  end

  #
  # => UPDATE BLOCK
  #
  test "should_update_company_with_skills" do
    client = get_valid_mock_client
    Client.stubs(:find).returns(client)

    skills = get_valid_skill(false, -1, @skills)
    skills.each_with_index{|s,i|
      s.id = i
    }

    Skill.stubs(:load_skills).returns(skills)

    company = Company.new
    company = stub(:name= => 'Lab', :token= => 'tk12', :name => 'Lab',
          :client= => client, :client => client,
          :main_color => '#FF00FF', :main_color= => '#FF00FF',
          :token => 'tk12', :id => 1, :id= => 1,
          :manager_name => 'manager name',
          :manager_name= => 'manager name',
          :email => 'manager@company.com',
          :email= => 'manager@company.com',
          :active => true,
          :active= => true,
          :main_color= => '#FF00FF',
          :valid? => true, :nil? => false, :skills= => skills, :skills => skills)

    company_temp = Company.new
    company_temp = stub(:name= => '', :token= => 'tk123',
          :client= => client, :client => client,
          :main_color => '#FF00FF', :main_color= => '#FF00FF',
          :token => 'tk12', :id => 1,
          :nil? => false, :skills= => skills,
          :manager_name= => 'manager name',
          :email= => 'manager@company.com',
          :active= => true,
          :main_color= => '#FF00FF'
          )


    company_temp.stubs(:save).returns(true).once

    Company.stubs(:find_by).returns(company_temp)
    Company.stubs(:new).returns(company)

    params = @valid_params
    params[:client_id] = client.id
    params[:skills] = skills
    params[:id] = 22
    add_client_token_param(params, client)
    put '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
  end

  test "should_not_update_company_with_skills_without_name" do
    client = get_valid_mock_client
    Client.stubs(:find).returns(client)

    skills = get_valid_skill(false, -1, @skills)
    skills.each_with_index{|s,i|
      s.id = i
    }

    Skill.stubs(:load_skills).returns(skills)

    company = Company.new
    company = stub(:name= => '', :token= => 'tk12',
          :client= => client,
          :main_color= => '#FF00FF',
          :id= => 1,
          :manager_name= => 'manager name',
          :email= => 'manager@company.com',
          :active= => true,
          :valid? => false, :nil? => false, :skills= => skills, :skills => skills, :errors => @name_required)

    Company.stubs(:new).returns(company)
    company.stubs(:save).returns(true).never
    #call
    params = @valid_params
    params[:client_id] = client.id
    params[:skills] = @skills
    params[:id] = client.id
    add_client_token_param(params, client)
    put '/api/v1/company', params
    #checks
    valid_bad_request(response, {'name' => ''})
  end

  test "should_not_update_company_not_passing_id" do
    client = get_valid_mock_client
    params = @valid_params
    add_client_token_param(params, client)
    put '/api/v1/company', params
    message = valid_bad_request(response, {'id' => ''})
  end

  test "should_not_update_company_duplicate_token" do
    client = get_valid_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:name= => 'Lab',
          :token= => 'tk12',
          :client= => client,
          :main_color= => '#FF00FF',
          :email= => 'manager@company.com',
          :manager_name= => 'manager name',
          :active= => true,
          :id= => 1, :skills => nil,
          :valid? => false, :errors => @duplicate_token_message)
    company.stubs(:save).returns(true).never

    Company.stubs(:new).returns(company)
    Company.stubs(:find_by).returns(nil)

    params = @valid_params
    params[:client_id] = client.id
    params[:id] = 4433
    add_client_token_param(params, client)
    put '/api/v1/company', params
    message = valid_bad_request(response, {'token' => ''})

  end

  test "should_not_update_company_with_skills" do
    params = @valid_params
    add_client_token_param(params, get_valid_mock_client)
    put '/api/v1/company', params
    print_response(response)
    valid_bad_request(response, {'id' => 'Field required'})
  end

  #
  # => FIND BLOCK
  #

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
    company_temp.token = 'hhtii'

    #Company.stubs(:find_by).returns(company_temp)
    projects = mock()
    Company.stubs(:includes).returns(projects)
    projects.stubs(:where).returns([company_temp])

    get "/api/v1/company/token/#{company_temp.token}"
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
    get "/api/v1/company/token/e3"
    assert_response :not_found
  end
=begin
  test "should_find_company_by_client_id" do
    client = Client.new
    client = stub(:nil? => false, :to_i => 1)
    client_id = 334
    skills = get_valid_skill(false, -1, @skills)

    #company_temp = get_valid_company(false)
    #company_ret = Company.new

    company_temp = Company.new
    company_temp = stub(
          :skills => skills)
    content = [company_temp]
    company = Company.new
    #company = stub(:all => company_temp)

    Client.stubs(:find_by).returns(client)
    Company.stubs(:where).returns(company)
    #Array.stubs(:all).returns([company])
    Company.stubs(:all).returns(company_temp)

    get "/api/v1/company/#{client_id}"
    message = valid_success_request(response)
    print_response(response)
    #assert_equal company_temp.id, message["id"]
    assert_equal company.name, message["name"]
    assert_equal skills.size, message["skills"].size
    assert_equal skills[0].name, message["skills"][0]['name']
    assert_equal skills[0].points, message["skills"][0]['points']
    assert_equal skills[1].name, message["skills"][1]['name']
    assert_equal skills[1].points, message["skills"][1]['points']
    assert_equal skills[2].name, message["skills"][2]['name']
    assert_equal skills[2].points, message["skills"][2]['points']
  end
=end
  test "should_not_find_company_by_client_id" do
    client = get_valid_mock_client
    client.stubs(:nil?).returns(false)
    Client.stubs(:find_by).returns()
    Company.stubs(:where).returns(nil)
    get "/api/v1/company/80808080980"
    assert_response :not_found
  end

  test "should_find_full_company_by_token" do
    company_temp = get_valid_company(false)
    tech_tags = get_valid_teck_tag(false, ['JAVA', 'ORACLE', 'RUBY', 'GIT'])
    tech_tags.each_with_index{|s,i|
      s.id = i
    }
    projects = get_valid_project(false, 2)
    projects.each_with_index{|s,i|
      s.id = i
    }

    projects[0].tech_tags = tech_tags[0..1]
    projects[1].tech_tags = tech_tags[2..3]

    skills = get_valid_skill(false, -1, @skills)
    company_temp.skills = skills
    company_temp.projects = projects

    projects_mock = mock()
    Company.stubs(:includes).returns(projects_mock)
    projects_mock.stubs(:where).returns([company_temp])

    get "/api/v1/company/token/cmpToken"
#    puts 'response'
#    puts response.body
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
    assert_equal projects.size, message["projects"].size
    assert_equal projects[0].name, message["projects"][0]['name']
    assert_equal projects[0].summary, message["projects"][0]['summary']
    assert_equal projects[0].project_date.strftime('%D'),
                      Date.parse(message["projects"][0]['project_date']).strftime('%D')
    assert_equal projects[1].name, message["projects"][1]['name']
    assert_equal projects[1].summary, message["projects"][1]['summary']
    assert_equal projects[1].project_date.strftime('%D'),
                      Date.parse(message["projects"][1]['project_date']).strftime('%D')
    assert_not_nil message["projects"][0]['tech_tags']
    assert_equal projects[0].tech_tags[0].name, message["projects"][0]['tech_tags'][0]['name']
    assert_equal projects[1].tech_tags[0].name, message["projects"][1]['tech_tags'][0]['name']
    assert_equal 2, message["projects"][0]['tech_tags'].size
    assert_equal 2, message["projects"][1]['tech_tags'].size
    assert_nil message["projects"][0]['created_at']
    assert_nil message["projects"][0]['language']

  end

  test "should_return_tech_tags_by_company_token" do

    tech_tag_1 = TechTag.new
    tech_tag_1 = stub(:name => 'JAVA')
    tech_tag_2 = TechTag.new
    tech_tag_2 = stub(:name => 'SQL')
    tech_tag_3 = TechTag.new
    tech_tag_3 = stub(:name => 'ORACLE')
    tech_tag_4 = TechTag.new
    tech_tag_4 = stub(:name => 'SQL')

    project_1 = Project.new
    project_1 = stub(:tech_tags => [tech_tag_1, tech_tag_2])
    project_2 = Project.new
    project_2 = stub(:tech_tags => [tech_tag_3, tech_tag_4])

    company = Company.new
    company = stub(:projects => [project_1, project_2], :skills => nil)

    projects_mock = mock()
    Company.stubs(:includes).returns(projects_mock)
    projects_mock.stubs(:where).returns([company])

    get "/api/v1/company/tech/cmpToken"
    message = valid_success_request(response)
    assert_equal 3, message["tech_tags"].size
    assert_equal tech_tag_1.name, message["tech_tags"][0]
    assert_equal tech_tag_2.name, message["tech_tags"][1]
    assert_equal tech_tag_3.name, message["tech_tags"][2]
  end

  test "should_not_return_tech_tags_by_company_token_returning_empty" do
    projects_mock = mock()
    Company.stubs(:includes).returns(projects_mock)

    companies = mock()
    companies = stub(:empty? => true, :nil? => false)
    projects_mock.stubs(:where).returns(companies)
    get "/api/v1/company/tech/cmpToken"
    assert_response :not_found
  end

  test "should_not_return_tech_tags_by_company_token_returning_nil" do
    projects_mock = mock()
    Company.stubs(:includes).returns(projects_mock)

    companies = mock()
    companies = stub(:nil? => true)
    projects_mock.stubs(:where).returns(companies)
    get "/api/v1/company/tech/cmpToken"
    assert_response :not_found
  end

  test "should_find_company_skills_by_token" do
    skills = get_valid_skill(false, -1, @skills)
    company_temp = Company.new
    company_temp = stub(:skills => skills, :nil? => false)
    Company.stubs(:find_by).returns(company_temp)

    get "/api/v1/company/skill/cmpToken"
    message = valid_success_request(response)
#    puts 'response'
#    puts message
    assert_equal 3, message['skills'].size
    assert_equal @skills[0], message['skills'][0]['name']
    assert_equal @skills[1], message['skills'][1]['name']
    assert_equal @skills[2], message['skills'][2]['name']

  end

  test "should_not_find_company_skills_by_token" do
    company_temp = Company.new
    company_temp = stub(:nil? => true)
    Company.stubs(:find_by).returns(company_temp)

    get "/api/v1/company/skill/cmpToken"
    assert_response :not_found
  end

  test "should_not_find_company_skills_by_token_returning_nil_skills" do
    company_temp = Company.new
    company_temp = stub(:nil? => false, :skills => nil)
    Company.stubs(:find_by).returns(company_temp)

    get "/api/v1/company/skill/cmpToken"
    assert_response :not_found
  end

  test "should_not_find_company_skills_by_token_returning_empty_skills" do
    skills = mock()
    skills = stub(:empty? => true)
    company_temp = Company.new
    company_temp = stub(:nil? => false, :skills => skills)
    Company.stubs(:find_by).returns(company_temp)

    get "/api/v1/company/skill/cmpToken"
    assert_response :not_found
  end

end
