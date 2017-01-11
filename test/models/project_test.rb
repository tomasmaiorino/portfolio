require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should_not_save_project" do
    project = Project.new
    assert !project.valid?
    assert !project.save

    project = Project.new
    project.name = 'integration'
    assert !project.valid?
    assert !project.save

    project = Project.new
    project.name = 'integration'
    project.img = 'integration.png'
    assert !project.valid?
    assert !project.save

    project = Project.new
    project.name = 'integration'
    project.img = 'integration.png'
    project.link_img = 'http://localhost/img.png'
    assert !project.valid?
    assert !project.save

    project = Project.new
    project.name = 'integration'
    project.img = 'integration.png'
    project.link_img = 'http://localhost/img.png'
    project.summary = 'Integration between systems'
    assert !project.valid?
    assert !project.save

    project = Project.new
    project.name = 'integration'
    project.img = 'integration.png'
    project.link_img = 'http://localhost/img.png'
    project.summary = 'Integration between systems'
    project.project_date = Time.now
    assert !project.valid?
    assert !project.save

    project = Project.new
    project.name = 'integration'
    project.img = 'integration.png'
    project.link_img = 'http://localhost/img.png'
    project.summary = 'Integration between systems'
    project.project_date = Time.now
    assert !project.valid?
    assert !project.save
  end

  test "should_save_project" do
    project = Project.new
    project.name = 'integration'
    project.img = 'integration.png'
    project.link_img = 'http://localhost/img.png'
    project.summary = 'Integration between systems'
    project.project_date = Time.now
    project.time_spent = '2 weeks'
    assert project.valid?
    assert project.save

  end

  test "should_save_project_with_tech_tags" do
    tech_tags = get_valid_teck_tag(true, ['JAVA', 'JSP', 'JQUERY'])
    project = get_valid_project(false)
    project.tech_tags = tech_tags
    assert project.save

    project_id = project.id
    project_temp = Project.find_by(id: project_id)
    assert_not_nil project_temp
    assert_equal  project_id, project_temp.id
    assert_not_empty project_temp.tech_tags
    assert_equal 3, project_temp.tech_tags.size
    assert_equal 'JAVA', project_temp.tech_tags[0].name
    assert_equal 'JSP', project_temp.tech_tags[1].name
    assert_equal 'JQUERY', project_temp.tech_tags[2].name
  end

  test "should_save_project_with_companies" do
    client = get_valid_client(true)
    project = get_valid_project(false)

    companies = get_valid_company(true, client, 2)
    project.companies = companies
    assert project.valid?
    assert project.save

    project_id = project.id
    project_temp = Project.find_by(id: project_id)
    assert_not_nil project_temp
    assert_equal  project_id, project_temp.id
    assert_not_empty project_temp.companies
    assert_equal 2, project_temp.companies.size
    assert_equal companies[0].id, project_temp.companies[0].id
    assert_equal companies[1].id, project_temp.companies[1].id
    assert_equal companies[0].name, project_temp.companies[0].name
    assert_equal companies[1].name, project_temp.companies[1].name
  end

  test "should_save_project_with_companies_and_tech_tag" do
    client = get_valid_client(true)

    project = get_valid_project(false)
    companies = get_valid_company(true, client, 2)
    project.companies = companies

    tech_tags = get_valid_teck_tag(true, ['JAVA', 'JSP', 'JQUERY'])
    project.tech_tags = tech_tags

    assert project.valid?
    assert project.save

    project_id = project.id
    project_temp = Project.find_by(id: project_id)
    assert_not_nil project_temp
    assert_equal  project_id, project_temp.id
    assert_not_empty project_temp.companies
    assert_equal 2, project_temp.companies.size
    assert_equal companies[0].id, project_temp.companies[0].id
    assert_equal companies[1].id, project_temp.companies[1].id
    assert_equal companies[0].name, project_temp.companies[0].name
    assert_equal companies[1].name, project_temp.companies[1].name

    assert_not_empty project_temp.tech_tags
    assert_equal 3, project_temp.tech_tags.size
    assert_equal 'JAVA', project_temp.tech_tags[0].name
    assert_equal 'JSP', project_temp.tech_tags[1].name
    assert_equal 'JQUERY', project_temp.tech_tags[2].name
  end

  test "should_return_project_by_companies" do
    project = get_full_project(true)

    #temp_project = Project.includes(:companies).where(:companies => {id: project.companies[0].id})
    temp_project = Project.joins(:companies).where(:companies => {id: project.companies[0].id})

    assert_not_nil temp_project
    assert_equal 1, temp_project.size
    assert_equal project.id, temp_project[0].id
    assert_equal project.companies.size, temp_project[0].companies.length
    assert_not_empty temp_project[0].companies
    assert_equal project.companies[0].id, temp_project[0].companies[0].id
    assert_equal project.companies[1].id, temp_project[0].companies[1].id
    assert_equal project.companies[1].name, temp_project[0].companies[1].name
    assert_equal project.companies[0].name, temp_project[0].companies[0].name

  end

  test "should_return_complete_project_by_companies" do
    Project.delete_all
    project = get_full_project(true)
    project_temp = Project.find(project.id)
    assert_not_nil project_temp
    assert_equal project.id, project_temp.id
    assert_not_empty project_temp.companies
    assert_not_empty project_temp.tech_tags
    assert_equal project.companies.size, project_temp.companies.size
    assert_equal project.tech_tags.size, project_temp.tech_tags.size
    assert_not_nil project_temp.companies[0].client
    assert_equal project.companies[0].client, project_temp.companies[0].client
  end

  test "should_not_return_project_by_id" do
   assert_raise (ActiveRecord::RecordNotFound){
     Project.delete_all
     project = get_full_project(true)
     project_temp = Project.find(33)
   }
 end


#
# => TO FIX
#
=begin
  test "should_return_project_by_tech_tags" do
    client = get_valid_client(true)
    projects = get_valid_project(true, 2)

    companies = get_valid_company(true, client, 4)
    projects[0].companies = companies[0..1]
    projects[1].companies = companies[2..3]

    tech_tags = get_valid_teck_tag(true, ['JAVA', 'JSP', 'JQUERY'])

    projects[0].tech_tags = tech_tags
    projects[1].tech_tags = tech_tags

    assert projects[0].save
    assert projects[1].save

    temp_project = Project.includes(:tech_tags).where(tech_tags: {id: tech_tags[0].id})

    assert_not_nil temp_project
    assert_not_empty temp_project
    assert_equal projects[0].id, temp_project[0].id
    assert_equal projects[1].id, temp_project[1].id
    assert_equal 2, temp_project.size
    assert_equal 3, temp_project[0].tech_tags.size
    assert_equal tech_tags[0].id, temp_project[0].tech_tags[0].id
    assert_equal tech_tags[0].id, temp_project[1].tech_tags[0].id
    assert_equal companies[0].id, temp_project[0].companies[0].id
    assert_equal companies[1].id, temp_project[0].companies[1].id
    assert_equal companies[2].id, temp_project[1].companies[2].id
    assert_equal companies[3].id, temp_project[1].companies[3].id
  end
=end

end
