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
  end

  def get_mock_client
    client = Client.new
    client.id = 2
    client.name = "Monsters"
    client.token = 'tk12'
    client.active = true
    client.security_permissions = 1
    return client
  end

#
# => CREATE BLOCK
#
  test "should_create_company_without_skills" do

    client = get_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:name= => 'Lab', :token= => 'tk12',
          :client= => client, :token => 'tk12', :id => 1)

    company.stubs(:save).returns(true).once
    company.stubs(:valid?).returns(true)
    Company.stubs(:new).returns(company)
    Company.stubs(:find_by).returns(nil)

    params = @valid_params
    params[:client_id] = client.id

    post '/api/v1/company', params
    print_response(response)
    message = valid_success_request(response, {'id' => ''})
  end

  test "should_not_create_company_without_name" do

    client = get_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:token= => 'tk12', :name= => '',
          :client= => client, :token => 'tk12', :id => 1, :errors => @name_required)

    company.stubs(:valid?).returns(false)
    Company.stubs(:new).returns(company)

    params = @invalid_params_no_name
    params[:client_id] = client.id

    post '/api/v1/company', params
    valid_bad_request(response, {'name' => ''})
  end

  test "should_not_create_company_without_token" do

    client = get_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:token= => 'tk12', :name= => '',
          :client= => client, :token => '', :id => 1, :errors => @token_required)

    company.stubs(:valid?).returns(false)
    Company.stubs(:new).returns(company)

    params = @invalid_params_no_token
    params[:client_id] = client.id

    post '/api/v1/company', params
    valid_bad_request(response, {'token' => ''})
  end

  test "should_not_create_company_without_client" do
    params = @valid_params
    post '/api/v1/company', params
    valid_bad_request(response, {'client_id' => ''})
  end

  test "should_not_create_company_invalid_client" do
    Client.stubs(:find).raises(ActiveRecord::RecordNotFound)

    params = @valid_params
    params[:client_id] = 23

    post '/api/v1/company', params
    valid_bad_request(response, {'client_id' => ''})
  end

  test "should_create_company_with_skills" do
    client = get_mock_client
    Client.stubs(:find).returns(client)

    skills = get_valid_skill(false, -1, @skills)
    skills.each_with_index{|s,i|
      s.id = i
    }

    Skill.stubs(:load_skills).returns(skills)

    company = Company.new
    company = stub(:name= => 'Lab', :token= => 'tk12',
          :client= => client, :client => client,
          :token => 'tk12', :id => 1,
          :valid? => true, :nil? => false, :skills= => skills)
    company.stubs(:save).returns(true).once

    Company.stubs(:new).returns(company)
    Company.stubs(:find_by).returns(nil)

    params = @valid_params
    params[:client_id] = client.id
    params[:skills] = @skills
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
  end

  #
  # => UPDATE BLOCK
  #
  test "should_update_company_with_skills" do
    client = get_mock_client
    Client.stubs(:find).returns(client)

    skills = get_valid_skill(false, -1, @skills)
    skills.each_with_index{|s,i|
      s.id = i
    }

    Skill.stubs(:load_skills).returns(skills)

    company = Company.new
    company = stub(:name= => 'Lab', :token= => 'tk12', :name => 'Lab',
          :client= => client, :client => client,
          :token => 'tk12', :id => 1,
          :valid? => true, :nil? => false, :skills= => skills, :skills => skills)

    company_temp = Company.new
    company_temp = stub(:name= => '', :token= => 'tk123',
          :client= => client, :client => client,
          :token => 'tk12', :id => 1,
          :nil? => false, :skills= => skills)

    company_temp.stubs(:save).returns(true).once

    Company.stubs(:find_by).returns(company_temp)
    Company.stubs(:new).returns(company)

    params = @valid_params
    params[:client_id] = client.id
    params[:skills] = skills
    params[:id] = 22
    put '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
  end

  test "should_not_update_company_with_skills_without_name" do
    client = get_mock_client
    Client.stubs(:find).returns(client)

    skills = get_valid_skill(false, -1, @skills)
    skills.each_with_index{|s,i|
      s.id = i
    }

    Skill.stubs(:load_skills).returns(skills)

    company = Company.new
    company = stub(:name= => '', :token= => 'tk12',
          :client= => client, :client => client,
          :token => 'tk12', :id => 1,
          :valid? => false, :nil? => false, :skills= => skills, :errors => @name_required)

    Company.stubs(:new).returns(company)
    company.stubs(:save).returns(true).never
    #call
    params = @valid_params
    params[:client_id] = client.id
    params[:skills] = @skills
    params[:id] = client.id
    put '/api/v1/company', params
    #checks
    valid_bad_request(response, {'name' => ''})
  end

  test "should_not_update_company_not_passing_id" do
    params = @valid_params
    put '/api/v1/company', params
    message = valid_bad_request(response, {'id' => ''})
  end

  test "should_not_update_company_duplicate_token" do
    client = get_mock_client
    Client.stubs(:find).returns(client)

    company = Company.new
    company = stub(:name= => 'Lab', :token= => 'tk12',
          :client= => client, :client => client,
          :token => 'tk12', :id => 1,
          :valid? => false, :errors => @duplicate_token_message)
    company.stubs(:save).returns(true).never

    Company.stubs(:new).returns(company)
    Company.stubs(:find_by).returns(nil)

    params = @valid_params
    params[:client_id] = client.id
    params[:id] = 4433
    put '/api/v1/company', params
    message = valid_bad_request(response, {'token' => ''})

  end

  test "should_not_update_company_with_skills" do
    params = @valid_params
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

  test "should_find_company_by_client_id" do
    company_temp = get_valid_company(false)
    client_id = 334
    skills = get_valid_skill(false, -1, @skills)
    Client.stubs(:find).returns(client_id)

    company_temp.skills = skills

    Company.stubs(:find_by).returns(company_temp)

    get "/api/v1/company/#{client_id}"
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

  test "should_find_company_by_client_id_not_found" do
    get "/api/v1/company/33"
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
    company = stub(:projects => [project_1, project_2])

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
end
