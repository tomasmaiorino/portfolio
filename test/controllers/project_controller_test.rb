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
        :future_project => false
        #:project_date => 1
        }
    @invalid_params = {
      :name => "Monsters",
      :img => "http://www.cnn.com;/img.jpg",
      :link_img => "http://www.cnn.com",
      :summary => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
      :description => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      :improvements => "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
      :time_spent => "2 weeks",
      :active => true,
      :future_project => false
        #:companies => [],
        #:tech_tags => []
      }
      @invalid_params_1 = {
          :name => '',
          :img => 'http://www.cnn.com;/img.jpg',
          :link_img => 'http://www.cnn.com',
          :summary => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ',
          :description => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris n',
          :improvements => 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore',
          :time_spent => '2 weeks',
          :active => true,
          :future_project => false,
          :project_date => 1,
          :companies => [],
          :tech_tags => []
        }
    @companies = [12, 31, 33]
    @tech_tags = [12, 23, 34]
    @name_required = {:name=>["Field Required"]}
  end

  test "should_not_create_project" do
    params = @invalid_params
    Project.any_instance.stubs(:valid).returns(false)
    Project.any_instance.stubs(:errors).returns(@name_required)

    post "/api/v1/project", params
    message = valid_bad_request(response, {'name' => 'Field Required'})
  end

end
