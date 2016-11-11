require 'test_helper'

class ProjectControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @valid_params = {
        :name => "Monsters",
        :img => "http://www.cnn.com;/img.jpg",
        :link_img => "http://www.cnn.com",
        :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
        :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        :improvements => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
        :time_spent => "2 weeks",
        :active => true,
        :future_project => false,
        :project_date => 1
        }

    @invalid_params = {
      :img => "http://www.cnn.com;/img.jpg",
      :link_img => "http://www.cnn.com",
      :summary => "summary summary summary summary summary summary summary summary ",
      :description => "description description description sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua description description description sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
      :improvements => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
      :time_spent => "2 weeks",
      :active => true,
      :future_project => false,
      :project_date => nil
      }

      #:companies => [],
      #:tech_tags => []
    @invalid_params_1 = {
        :name => 'Monsters',
        :img => 'http://www.cnn.com;/img.jpg',
        :link_img => 'http://www.cnn.com',
        :summary => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ',
        :description => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris n',
        :improvements => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore',
        :time_spent => '2 weeks',
        :active => true,
        :future_project => false

        #:companies => [],
        #:tech_tags => []
      }

    @companies = [1, 2, 3]
    @tech_tags = [1, 2, 3]
    @name_required = {:name=>["Field Required"]}
    @project_date_required = {:project_date=>["Field Required"]}

  end

  test "should_not_create_project_not_passing_name" do
    params = @valid_params
    params.delete(:name)
    Project.any_instance.stubs(:valid?).returns(false)
    Project.any_instance.stubs(:errors).returns(@name_required)

    post "/api/v1/project", params
    message = valid_bad_request(response, {'name' => 'Field Required'})
  end

  test "should_not_create_project_not_project_date" do
    params = @valid_params
    params.delete(:project_date)
    Project.any_instance.stubs(:valid?).returns(false)
    Project.any_instance.stubs(:errors).returns(@project_date_required)

    post "/api/v1/project", params
    message = valid_bad_request(response, {'project_date' => 'Field Required'})
  end

  test "should_return_companes" do
    client = get_valid_client(false)
    companies = get_valid_company(false, client, 3)
    companies.each_with_index {|c,i|
      c.id = i
    }
    params = @valid_params
    params[:companies] = @companies

    Company.stubs(:where).returns(companies)

    controller = ProjectController.new
    companies_temp = controller.configure_companies(params)
    assert_not_nil companies_temp
    assert_equal @companies.size, companies_temp.size
    assert_equal @companies[0], companies_temp[1].id
  end

  test "should_not_return_companies" do
    client = get_valid_client(false)
    companies = get_valid_company(false, client, 3)
    companies.each_with_index {|c,i|
      c.id = i
    }
    invalid_company = [2, 4, 1]
    params = @valid_params
    params[:companies] = invalid_company

    Company.stubs(:where).returns([])

    controller = ProjectController.new
    assert_empty controller.configure_companies(params)
  end

  test "should_not_return_companies_passing_invalid_id" do
    controller = ProjectController.new
    assert_nil controller.configure_companies(@valid_params)
  end

  test "should_not_return_companies_passing_nil" do
    controller = ProjectController.new
    assert_nil controller.configure_companies(nil)
  end

  #-------------------------
  test "should_return_tech_tags" do
    client = get_valid_client(false)
    tech_tags = get_valid_company(false, client, 3)
    tech_tags.each_with_index {|c,i|
      c.id = i
    }
    params = @valid_params
    params[:tech_tags] = @tech_tags

    Company.stubs(:where).returns(tech_tags)

    controller = ProjectController.new
    tech_tags = controller.configure_tech_tags(params)
    assert_not_nil tech_tags
    assert_equal @tech_tags.size, tech_tags.size
    assert_equal @tech_tags[0], tech_tags[1].id
  end

test "should_not_return_tech_tags" do

  TechTag.stubs(:load_tech_tags).returns([])

  controller = ProjectController.new
  assert_empty controller.configure_tech_tags([])
end

test "should_not_return_tech_tags_passing_invalid_id" do
  controller = ProjectController.new
  assert_nil controller.configure_tech_tags(@valid_params)
end

test "should_not_return_tech_tags_passing_nil" do
  controller = ProjectController.new
  assert_nil controller.configure_tech_tags(nil)
end

end
