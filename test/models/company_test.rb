require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def get_client()
    client = Client.new
    client.name = 'test'
    client.token = 'xx11xx'
    return client
  end


  test "should_not_save_company" do
    company = Company.new
    assert !company.valid?
    assert !company.save

    company = Company.new
    company.name = 'monsters'
    assert !company.valid?
    assert !company.save

    company = Company.new
    company.token = 'xxss11'
    assert !company.valid?
    assert !company.save

    company = Company.new
    company.token = 'xxss11'
    company.name = 'monsters'
    assert !company.valid?
    assert !company.save
  end

  test "should_not_save_company_passing_duplicate_token" do
    client = get_client
    company = Company.new
    company.name = 'monsters'
    company.token = 'xxss11'
    company.client = client
    assert company.save

    company = Company.new
    company.name = 'monsters'
    company.token = 'xxss11'
    company.client = client
    assert !company.valid?
    assert !company.save

    company = Company.new
    company.name = 'monsters'
    company.token = 'xxSS11'
    company.client = client
    assert !company.valid?
    assert !company.save

  end

  test "should_save_company" do
    client = get_client

    company = Company.new
    company.name = 'monsters'
    company.token = 'xxss11'
    company.client = client
    assert company.valid?
    assert company.save

    company = Company.new
    company.name = 'monsters'
    company.token = 'xxss12'
    company.client = client
    company.active = true
    company.email = 'monsters@monsters.com'
    company.manager_name = 'David'
    assert company.valid?
    assert company.save

  end

  test "should_return_company_by_token" do
    client = get_valid_client(true)
    company = get_valid_company(true, client)
    company_temp = Company.find_by(:token => company.token)
    assert_not_nil company_temp
    assert_equal company.id, company_temp.id
    assert_equal company.token, company_temp.token
    assert_equal company.client.id, company_temp.client.id
  end

  test "should_return_company_by_client" do
    Company.delete_all
    client = get_valid_client(true)
    company = get_valid_company(true, client, 2)
    companies = Company.where(:client => client)
    assert_not_nil companies
    assert_not_empty companies
    assert_equal 2, companies.size
    assert_equal company[0].token, companies[0].token
    assert_equal company[1].token, companies[1].token
    assert_equal company[0].client.id, companies[0].client.id
    assert_equal company[0].client.id, companies[1].client.id
  end

  test "should_save_company_with_skills" do
    client = get_valid_client(true)
    company = get_valid_company(false, client)
    skills = get_valid_skill(false, 3)
    company.skills = skills

    assert company.valid?
    assert company.save
    company_temp = Company.find(company.id)

    assert_not_nil company_temp
    assert_equal skills.size, company_temp.skills.size
    assert_equal company.client.id, company_temp.client.id
    assert_equal skills[0].id, company_temp.skills[0].id

  end

  test "should_update_company_with_skills" do
    client = get_valid_client(true)
    company = get_valid_company(false, client)
    skills = get_valid_skill(false, 3)
    company.skills = skills

    assert company.valid?
    assert company.save
    company_temp = Company.find(company.id)

    assert_not_nil company_temp
    assert_equal skills.size, company_temp.skills.size
    assert_equal company.client.id, company_temp.client.id
    assert_equal skills[0].id, company_temp.skills[0].id

    old_size = company_temp.skills.size

    skill = get_valid_skill(false)
    skill.name = 'java'

    company.skills << skill
    assert company.valid?
    assert company.save
    company_temp = Company.find(company.id)
    assert_not_nil company_temp
    assert_equal old_size + 1, company_temp.skills.size
    assert_equal company.client.id, company_temp.client.id
    assert_equal skills[0].id, company_temp.skills[0].id
    assert_equal skill.name, company_temp.skills[company_temp.skills.size - 1].name
    assert_equal company.skills, company_temp.skills

    Rails.logger.debug "skills #{company_temp.skills}"
    company.skills.delete_at(company.skills.index{|x| x.name == 'atg 1'})

    assert company.valid?
    assert company.save

    company_temp = Company.find(company.id)
    assert_not_nil company_temp
    assert_equal old_size, company_temp.skills.size
    assert_equal company.client.id, company_temp.client.id
    assert_equal skills[0].id, company_temp.skills[0].id
    assert_equal skill.name, company_temp.skills[company_temp.skills.size - 1].name
    assert_equal company.skills, company_temp.skills


  end

end
