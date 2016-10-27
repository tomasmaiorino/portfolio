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
    #client = get_valid_client(true)
    company = get_valid_company(true)
    company_2 = get_valid_company(false)
    company_2.token = 'xxffxx'
    assert company_2.save

    project.companies = [company, company_2]
    assert project.save

    project_id = project.id
    project_temp = Project.find_by(id: project_id)
    assert_not_nil project_temp
    assert_equal  project_id, project_temp.id
    assert_not_empty project_temp.tech_tags
    assert_equal 2, project_temp.companies.size
    assert_equal company.id, project_temp.companies[0].id
    assert_equal company.id, project_temp.companies[1].id
    assert_equal company.name, project_temp.companies[1].name
    assert_equal company.name, project_temp.companies[1].name
  end
end
