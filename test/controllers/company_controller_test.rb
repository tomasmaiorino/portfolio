require 'test_helper'

class CompanyControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @skill = {:name => 'java', :points => 30}
    @skill_2 = {:name => 'oracle', :points => 40}
    @skill_3 = {:name => 'sql', :points => 60}
    @client = {:name => 'tomas', :active => true, :token => 'xxffwf' }
    @client_invalid = {:name => 'tomas', :active => true}
    @client_broken = {:temp => 'tomas', :active => true}
    @valid_skill_params = @skill, @skill_2, @skill_3
    @valid_params = {
      :name => 'tomas',
      :token => 'xxffwf',
      :client => @client,
      #:client => @client,
      :skills => @valid_skill_params
    }
  end
  test "should_create_company" do
    params = @valid_params
    post '/api/v1/company', params
    print_response(response)
    message = valid_bad_request(response, {'id' => ''})
  end

  test "should_return_invalid_client" do
    comp = CompanyController.new
    @valid_params[:client] = @client_invalid
    company = JSON.parse( @valid_params.to_json, symbolize_names: true)
    client = comp.configure_client(company)
    assert_not_nil client
    assert !client.valid?
    assert !client.errors.messages[:token].nil?
  end

  test "should_return_nil_client" do
    comp = CompanyController.new
    @valid_params[:client] = @client_broken
    company = JSON.parse( @valid_params.to_json, symbolize_names: true)
    client = comp.configure_client(company)
    assert_nil client
  end

  test "should_create_client" do
    comp = CompanyController.new
    company = JSON.parse( @valid_params.to_json, symbolize_names: true)
    client = comp.configure_client(company)
    assert_not_nil client
    assert client.valid?
    assert_not_nil client.id
    assert_equal @client[:name], client.name
    assert_equal @client[:token], client.token
  end

  test "should_recover_client" do

    comp = CompanyController.new
    company = JSON.parse( @valid_params.to_json, symbolize_names: true)
    client = comp.configure_client(company)
    assert_not_nil client
    assert_not_nil client.id
    assert_equal @client[:name], client.name
    assert_equal @client[:token], client.token

    client_temp = comp.configure_client(company)
    assert_not_nil client_temp
    assert_not_nil client_temp.id
    assert_equal @client[:name], client_temp.name
    assert_equal @client[:token], client_temp.token
    assert_equal client.id, client_temp.id
    assert_equal client.name, client_temp.name
    assert_equal client.token, client_temp.token
  end


end
