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
end
