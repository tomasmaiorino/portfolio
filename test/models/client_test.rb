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

end
