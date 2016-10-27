require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should_not_save_client" do
    client = Client.new
    assert !client.valid?
    assert !client.save

    client = Client.new
    client.name = 'monsters'
    assert !client.valid?
    assert !client.save

    client = Client.new
    client.token = 'xxss11'
    assert !client.valid?
    assert !client.save
  end

  test "should_not_save_client_passing_duplicate_token" do
    client = Client.new
    client.name = 'monsters'
    client.token = 'xxss11'
    assert client.save

    client = Client.new
    client.name = 'monsters'
    client.token = 'xxss11'
    assert !client.valid?
    assert !client.save

    client = Client.new
    client.name = 'monsters'
    client.token = 'xxSS11'
    assert !client.valid?
    assert !client.save

  end

  test "should_save_client" do
    client = Client.new
    client.name = 'monsters'
    client.token = 'xxss11'
    assert client.valid?
    assert client.save

    client = Client.new
    client.name = 'monsters'
    client.token = 'xxss12'
    client.active = true
    assert client.valid?
    assert client.save

  end

  test "should_have_client_companies" do
    client = Client.new
    client.name = 'monsters'
    client.token = 'xxss11'
    assert client.valid?
    assert client.save

    company_1 = get_valid_company(true, client)

    company_2 = get_valid_company(false, client)
    company_2.token = 'xxss123'
    company_2.save

    companies = client.companies
    assert_not_nil companies
    assert_not_empty companies
    assert_equal 2, companies.size
    assert_equal company_1.id, companies[0].id
    assert_equal company_2.id, companies[1].id

  end


end
