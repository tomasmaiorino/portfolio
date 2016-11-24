require 'test_helper'

class CompanyControllerIntegrationTest < ActionDispatch::IntegrationTest
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
    @client = get_valid_client(true)
  end

  test "integration_should_return_unauthorized_during_company_creation" do

    company = get_valid_company(false, @client)
    params = company.attributes
    params[:client_id] = @client.id

    post '/api/v1/company', params
    assert_response :unauthorized
  end

  test "integration_should_create_company_without_skills" do
    company = get_valid_company(false, @client)
    params = company.attributes
    params[:client_id] = @client.id

    add_client_token_param(params, @client)

    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
  end

  test "integration_should_create_company_with_skills" do
    company = get_valid_company(false, @client)
    params = company.attributes
    params[:client_id] = @client.id

    skills = get_valid_skill(true, -1, @skills)
    params[:skills] = skills

    add_client_token_param(params, @client)

    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})

  end

  test "integration_should_not_update_company_duplicate_token" do
    companies = get_valid_company(false, @client, 2)
    params = companies[0].attributes
    params[:client_id] = @client.id

    skills = get_valid_skill(false, -1, @skills)
    params[:skills] = skills
    #company 1
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_1_id = message['id']

    params = companies[1].attributes
    params[:client_id] = @client.id

    skills = get_valid_skill(false, -1, @skills)
    params[:skills] = skills

    #company 2
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})

    params[:id] = company_1_id
    companies[0].token = companies[1].token
    companies[0].id = company_1_id
    params = companies[0].attributes
    params[:client_id] = @client.id
    params[:skills] = skills

    #update
    add_client_token_param(params, @client)
    put '/api/v1/company', params
    print_response(response)
    message = valid_bad_request(response, {'token' => ''})
  end

  test "integration_should_throw_unauthorized_for_update_company_with_skills" do
    companies = get_valid_company(false, @client, 2)
    skills = get_valid_skill(false, -1, @skills)

    params = companies[0].attributes
    params[:client_id] = @client.id
    params[:skills] = skills
    #company 1
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message['id']

    companies[0].id = company_id
    companies[0].token = 'new_token'
    params = companies[0].attributes
    params[:client_id] = @client.id
    params[:skills] = skills[0..1]

    put '/api/v1/company', params
    assert_response :unauthorized
  end

  test "integration_should_update_company_with_skills" do
    companies = get_valid_company(false, @client, 2)
    skills = get_valid_skill(false, -1, @skills)

    params = companies[0].attributes
    params[:client_id] = @client.id
    params[:skills] = skills
    #company 1
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message['id']

    companies[0].id = company_id
    companies[0].token = 'new_token'
    params = companies[0].attributes
    params[:client_id] = @client.id
    params[:skills] = skills[0..1]

    add_client_token_param(params, @client)
    put '/api/v1/company', params
    #print_response(response)
    message = valid_success_request(response, {'id' => company_id})
  end

  test "integration_should_not_update_company_with_skills" do
    params = @valid_params
    add_client_token_param(params)
    put '/api/v1/company', params
    print_response(response)
    valid_bad_request(response, {'id' => 'Field required'})
  end

  test "integration_should_return_nil_skills" do
    company_controlle = CompanyController.new
    assert_nil company_controlle.configure_skills(nil)
    company = {}
    assert_nil company_controlle.configure_skills(company)
    company = {:client_id => 33322}
    assert_nil company_controlle.configure_skills(company)
  end

  test "integration_should_return_skills" do
    skills = get_valid_skill(true, -1, @skills)
    company_controlle = CompanyController.new
    company = {:skills => @skills}
    skills_temp = company_controlle.configure_skills(company)
    assert_not_nil skills_temp
    assert_not_empty skills_temp
    assert_equal skills.size, skills_temp.size
    assert_equal skills[0].name, skills_temp[0].name
  end


  test "integration_should_find_company_by_token_not_found" do
    get "/api/v1/company/token/tk"
    assert_response :not_found
  end

  test "integration_should_find_company_by_client_id" do
    company = get_valid_company(false, @client)
    params = company.attributes
    params[:client_id] = @client.id

    skills = get_valid_skill(true, -1, @skills)
    params[:skills] = [skills[0].name,skills[1].name,skills[2].name ]

    add_client_token_param(params, @client)

    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message['id']

    get "/api/v1/company/#{@client.id}"
    message = valid_success_request(response)
    #print_response(response)
    message = message[0]
    assert_equal company_id, message["id"]
    assert_equal company.name, message["name"]
    assert_equal skills.size, message["skills"].size
    assert_equal skills[0].name, message["skills"][0]['name']
    assert_equal skills[0].points, message["skills"][0]['points']
    assert_equal skills[1].name, message["skills"][1]['name']
    assert_equal skills[1].points, message["skills"][1]['points']
    assert_equal skills[2].name, message["skills"][2]['name']
    assert_equal skills[2].points, message["skills"][2]['points']
  end

  test "integration_should_find_company_by_client_id_not_found" do
    get "/api/v1/company/355445"
    assert_response :not_found
  end

  test "integration_should_find_company_by_client_id_not_found_with_company" do
    #create company
    company = get_valid_company(false, @client)
    params = company.attributes
    params[:client_id] = @client.id

    skills = get_valid_skill(true, -1, @skills)
    params[:skills] = skills
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})

    get "/api/v1/company/355445"
    assert_response :not_found
  end

  test "integration_should_find_full_company_by_token" do
    company = get_valid_company(false, @client)
    skills = get_valid_skill(true, 0, ['Java Programmer', 'Oracle ATG'])
    company.token = 'tOkTT'
    #
    # => company session
    #
    params = company.attributes
    params[:skills] = [skills[0].name, skills[1].name]

    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message["id"]

    #
    # => tech_tag session
    #
    tech_tags = get_valid_teck_tag(true, ['JAVA', 'ORACLE', 'GIT', 'RUBY', 'RAILS'])
    #
    # => project session
    #
    projects = get_valid_project(true, 3)
    #create first project
    project_1 = projects[0]

    project_1.tech_tags = tech_tags[0..2]

    project_2 = projects[1]
    project_2.tech_tags = tech_tags[1..4]

    params = project_1.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    params = project_2.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    get "/api/v1/company/token/#{company.token}"
    company_get = valid_success_request(response)
    assert_not_nil company_get
    assert_equal company_id, company_get["id"]
    assert_equal company.name, company_get["name"]
    assert_not_empty company_get["skills"]
    assert_equal projects.size - 1, company_get["projects"].size
    assert_equal project_1.name, company_get["projects"][0]['name']
    assert_equal project_1.img, company_get["projects"][0]['img']
    assert_equal project_1.tech_tags.size, company_get["projects"][0]['tech_tags'].size
    assert_equal project_1.tech_tags[0].name, company_get["projects"][0]['tech_tags'][0]['name']
    assert_equal project_1.tech_tags[1].name, company_get["projects"][0]['tech_tags'][1]['name']

    assert_equal project_2.name, company_get["projects"][1]['name']
    assert_equal project_2.img, company_get["projects"][1]['img']
    assert_equal project_2.tech_tags.size, company_get["projects"][1]['tech_tags'].size
    assert_equal project_2.tech_tags[0].name, company_get["projects"][1]['tech_tags'][0]['name']
    assert_equal project_2.tech_tags[1].name, company_get["projects"][1]['tech_tags'][1]['name']
    assert_equal project_2.tech_tags[2].name, company_get["projects"][1]['tech_tags'][2]['name']

  end

  test "integration_should_find_full_company_by_token_using_inactive_projects" do
    company = get_valid_company(false, @client)
    skills = get_valid_skill(true, 0, ['Java Programmer', 'Oracle ATG'])
    company.token = 'tOkTT'
    #
    # => company session
    #
    params = company.attributes
    params[:skills] = [skills[0].name, skills[1].name]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message["id"]

    #
    # => tech_tag session
    #
    tech_tags = get_valid_teck_tag(true, ['JAVA', 'ORACLE', 'GIT', 'RUBY', 'RAILS'])
    #
    # => project session
    #
    projects = get_valid_project(true, 3)
    #create first project
    project_1 = projects[0]

    project_1.tech_tags = tech_tags[0..2]

    project_2 = projects[1]
    project_2.active = false
    project_2.save
    project_2.tech_tags = tech_tags[1..4]

    params = project_1.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    params = project_2.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    get "/api/v1/company/token/#{company.token}"
    company_get = valid_success_request(response)
    assert_not_nil company_get
    assert_equal company_id, company_get["id"]
    assert_equal company.name, company_get["name"]
    assert_equal project_1.name, company_get["projects"][0]['name']
    assert_equal project_1.img, company_get["projects"][0]['img']
    assert_equal project_1.tech_tags.size, company_get["projects"][0]['tech_tags'].size
    assert_equal project_1.tech_tags[0].name, company_get["projects"][0]['tech_tags'][0]['name']
    assert_equal project_1.tech_tags[1].name, company_get["projects"][0]['tech_tags'][1]['name']
    assert_equal projects.size - 2, company_get["projects"].size

  end

  test "integration_should_find_company_tech_tags" do
    company = get_valid_company(false, @client)
    skills = get_valid_skill(true, 0, ['Java Programmer', 'Oracle ATG'])
    company.token = 'tOkTT'
    #
    # => company session
    #
    params = company.attributes
    params[:skills] = [skills[0].name, skills[1].name]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message["id"]

    #
    # => tech_tag session
    #
    tech_tags = get_valid_teck_tag(true, ['JAVA', 'ORACLE', 'GIT', 'RUBY', 'RAILS'])
    #
    # => project session
    #
    projects = get_valid_project(true, 3)
    #create first project
    project_1 = projects[0]

    project_1.tech_tags = tech_tags[0..2]

    project_2 = projects[1]
    #project_2.active = false
    project_2.save
    project_2.tech_tags = tech_tags[1..3]

    params = project_1.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    params = project_2.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    get "/api/v1/company/tech/#{company.token}"
    tech_tags_temp = valid_success_request(response)
    assert_not_empty tech_tags
    assert_equal tech_tags.size - 1, tech_tags_temp["tech_tags"].size
    assert 'JAVA'.in? tech_tags_temp["tech_tags"]
    assert 'ORACLE'.in? tech_tags_temp["tech_tags"]
    assert 'GIT'.in? tech_tags_temp["tech_tags"]
    assert 'RUBY'.in? tech_tags_temp["tech_tags"]

  end

  test "integration_should_not_find_company_tech_tags" do
    company = get_valid_company(false, @client)
    skills = get_valid_skill(true, 0, ['Java Programmer', 'Oracle ATG'])
    company.token = 'tOkTT'
    #
    # => company session
    #
    params = company.attributes
    params[:skills] = [skills[0].id, skills[1].id]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message["id"]

    #
    # => tech_tag session
    #
    tech_tags = get_valid_teck_tag(true, ['JAVA', 'ORACLE', 'GIT', 'RUBY', 'RAILS'])
    #
    # => project session
    #
    projects = get_valid_project(true, 3)
    #create first project
    project_1 = projects[0]
    project_1.active = false
    project_1.save

    project_1.tech_tags = tech_tags[0..2]

    project_2 = projects[1]
    project_2.active = false
    project_2.save
    project_2.tech_tags = tech_tags[1..3]

    params = project_1.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    params = project_2.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    get "/api/v1/company/tech/#{company.token}"
    assert_response :not_found

  end

  test "integration_should_not_find_company_project_tech_tags" do
    company = get_valid_company(false, @client)
    skills = get_valid_skill(true, 0, ['Java Programmer', 'Oracle ATG'])
    company.token = 'tOkTT'
    #
    # => company session
    #
    params = company.attributes
    params[:skills] = [skills[0].id, skills[1].id]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message["id"]

    #
    # => project session
    #
    projects = get_valid_project(true, 3)
    #create first project
    project_1 = projects[0]

    project_2 = projects[1]

    params = project_1.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    params = project_2.attributes
    params[:companies] = company_id
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})

    get "/api/v1/company/tech/#{company.token}"
    assert_response :not_found

  end

  test "integration_should_find_company_skills" do
    company = get_valid_company(false, @client)
    skills = get_valid_skill(true, 0, ['Java Programmer', 'Oracle ATG'])
    company.token = 'tOkTT'
    #
    # => company session
    #
    params = company.attributes
    params[:skills] = [skills[0].name, skills[1].name]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_id = message["id"]

    get "/api/v1/company/skill/#{company.token}"
    message = valid_success_request(response)
    #puts 'response'
    #puts message
    assert_not_nil message['skills']
    assert_not_empty message['skills']
    assert_equal skills.size, message['skills'].size
    assert_equal skills[0].name, message['skills'][0]['name']
    assert_equal skills[1].name, message['skills'][1]['name']
  end

  test "integration_should_find_client_company_by_token" do
    companies = get_valid_company(false, @client, 4)
    skills = get_valid_skill(true, 0, ['Java Programmer', 'Oracle ATG', 'Javascript', 'ATG'])

    #
    # => company session
    #
    #company 1
    params = companies[0].attributes
    params[:skills] = [skills[0].name, skills[1].name]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_1_id = message["id"]

    #company 2
    params = companies[1].attributes
    params[:skills] = [skills[2].name, skills[3].name]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_2_id = message["id"]

    #company 3
    params = companies[2].attributes
    params[:skills] = [skills[0].name, skills[3].name]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_3_id = message["id"]

    #company 4
    params = companies[3].attributes
    params[:active] = false
    params[:skills] = [skills[0].name, skills[3].name]
    add_client_token_param(params, @client)
    post '/api/v1/company', params
    message = valid_success_request(response, {'id' => ''})
    company_4_id = message["id"]

    #
    # => project session
    #
    projects = get_valid_project(true, 3)
    #create first project
    project_1 = projects[0]

    project_2 = projects[1]

    project_3 = projects[2]

    params = project_1.attributes
    params[:companies] = [company_1_id, company_2_id]
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})
    project_1_id = message['id']

    params = project_2.attributes
    params[:companies] = [company_3_id, company_4_id]
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})
    project_2_id = message['id']

    params = project_3.attributes
    params[:companies] = [company_1_id, company_2_id]
    add_client_token_param(params, @client)
    post "/api/v1/project", params
    message = valid_success_request(response, {'id' => ''})
    project_3_id = message['id']

    get "/api/v1/company/#{@client.id}"
    company_get = valid_success_request(response)
    #print_response(response)
    assert_not_nil company_get
    assert_not_empty company_get
    assert_equal companies.size - 1, company_get.size

    #checks company 1
    assert_equal company_1_id, company_get[0]['id']
    #company 1 should have 2 projects
    assert_equal 2, company_get[0]['projects'].size
    assert_equal project_1.name, company_get[0]['projects'][0]['name']
    assert_equal project_1.img, company_get[0]['projects'][0]['img']
    assert_equal project_3.name, company_get[0]['projects'][1]['name']
    assert_equal project_3.img, company_get[0]['projects'][1]['img']

    #checks company 2
    assert_equal company_2_id, company_get[1]['id']
    #company 2 should have 2 projects
    assert_equal 2, company_get[1]['projects'].size
    assert_equal project_1.name, company_get[1]['projects'][0]['name']
    assert_equal project_1.img, company_get[1]['projects'][0]['img']
    assert_equal project_3.name, company_get[1]['projects'][1]['name']
    assert_equal project_3.img, company_get[1]['projects'][1]['img']

    #checks company 3
    assert_equal company_3_id, company_get[2]['id']
    assert_equal project_2.name, company_get[2]['projects'][0]['name']
    assert_equal project_2.img, company_get[2]['projects'][0]['img']
  end

end
