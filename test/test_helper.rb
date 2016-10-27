ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def get_valid_client(create = false)
    client = Client.new
    client.name = 'monsters'
    client.token = 'xxss12'
    client.active = true
    client.save unless !create
    return client
  end

  def get_valid_teck_tag(create = false, tags = [])
    if (tags.empty?)
      tech_tag = TechTag.new
      tech_tag.name = 'JAVA'
      tech_tag.active = true
      tech_tag.save unless !create
      return tech_tag
    else
      techs = []
      tags.each{ |t|
        tech_tag = TechTag.new
        tech_tag.name = t
        tech_tag.active = true
        tech_tag.save unless !create
        techs << tech_tag
      }
      return techs
    end
  end

  def get_valid_skill(create = false)
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 2
    skill.save unless !create
    return skill
  end

  def get_valid_project(create = false)
    project = Project.new
    project.name = 'integration'
    project.img = 'integration.png'
    project.link_img = 'http://localhost/img.png'
    project.summary = 'Integration between systems'
    project.project_date = Time.now
    project.time_spent = '2 weeks'
    project.save unless !create
    return project
  end

  def get_valid_company (create = false, client = nil)
    company = Company.new
    company.name = 'monsters'
    company.token = 'xxss12'
    company.active = true
    company.client = client
    company.email = 'monsters@monsters.com'
    company.manager_name = 'David'
    company.save unless !create
    return company
  end
end
