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
end
