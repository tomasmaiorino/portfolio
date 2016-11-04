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

  def get_valid_skill(create = false, qt = 1)
    if (qt == 1)
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 2
    skill.save unless !create
    return skill
    else
      temp = []
      (1..qt).each{|t|
        skill = Skill.new
        skill.name = "atg #{t}"
        skill.points = 2 + t.to_i
        skill.save unless !create
        temp << skill
      }
      return temp
    end
  end

  def get_valid_project(create = false, qt = 1)
    if (qt == 1)
      project = Project.new
      project.name = 'integration'
      project.img = 'integration.png'
      project.link_img = 'http://localhost/img.png'
      project.summary = 'Integration between systems'
      project.project_date = Time.now
      project.time_spent = '2 weeks'
      project.save unless !create
      return project
    else
      temp = []
      (1..qt).each{|t|
        project = Project.new
        project.name = "integration #{t}"
        project.img = 'integration.png'
        project.link_img = 'http://localhost/img.png'
        project.summary = "Integration between systems #{t}"
        project.project_date = Time.now
        project.time_spent = '2 weeks'
        project.save unless !create
        temp << project
      }
      return temp
    end
  end

  def get_valid_company (create = false, client = nil, qt = 1)
    if (qt == 1)
      company = Company.new
      company.name = 'monsters'
      company.token = 'xxss12'
      company.active = true
      company.client = client
      company.email = 'monsters@monsters.com'
      company.manager_name = 'David'
      company.save unless !create
      return company
    else
      temp = []
      (1..qt).each{|n|
        company = Company.new
        company.name = "monsters #{n}"
        company.token = "token#{n}"
        company.active = true
        company.client = client
        company.email = "monsters#{n}@monsters.com"
        company.manager_name = "David #{n}"
        company.save unless !create
        temp << company
      }
      return temp
    end
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

  def get_full_project(create = false)

    client = get_valid_client(true)

    project = get_valid_project(false)
    companies = get_valid_company(true, client, 2)
    project.companies = companies

    tech_tags = get_valid_teck_tag(true, ['JAVA', 'JSP', 'JQUERY'])
    project.tech_tags = tech_tags
    project.save unless !create
    return project
  end

  def valid_bad_request(response, params = {}, debug = false)
    return valid_basic(:bad_request, response, params, debug)
=begin
    assert_response :bad_request
    message = response.body
    assert_not_nil message
    message = JSON.parse(message)

    params.each {|key, value|
      if debug
        Rails.logger.debug "params key = #{key}, value = #{value}"
        Rails.logger.debug "message key = #{message[key]}, value = #{message[key]}"
      end
       assert message.has_key?(key)
       assert_not_nil message[key]
       assert_equal value, message[key].kind_of?(Array) ? message[key][0] : message[key] unless value.blank?
    }
=end
  end


 def valid_basic(code, response, params = {}, debug = false)
   assert_response code
   message = response.body
   assert_not_nil message
   if (!message.blank?)
     message = JSON.parse(message)

     params.each {|key, value|
       if debug
         Rails.logger.debug "params key = #{key}, value = #{value}"
         Rails.logger.debug "message key = #{message[key]}, value = #{message[key]}"
       end
        assert message.has_key?(key)
        assert_not_nil message[key]
        assert_equal value, message[key].kind_of?(Array) ? message[key][0] : message[key] unless value.blank?
     }
     return message
   end
 end

  def valid_success_request(response, params = {}, debug = false)
    return valid_basic(:success, response, params, debug)
  end

end
