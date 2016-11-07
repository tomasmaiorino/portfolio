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
    client = get_valid_client(true)
    params = @valid_params
    params[:client_id] = client.id
    @valid_params[:client_id] = client.id

    Client.expects(:find).with(client.id).returns(client)
    Client.unstub(:find)
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
    skills = get_valid_skill(true, -1, @skills)
    Skill.expects(:load_skills).with(@skills).returns(skills)
    Skill.unstub(:load_skills)
    company_controlle = CompanyController.new
    company = {:skills => @skills}
    skills_temp = company_controlle.configure_skills(company)
    assert_not_nil skills_temp
    assert_not_empty skills_temp
    assert_equal skills.size, skills_temp.size
    assert_equal skills[0].id, skills_temp[0].id
  end


end
