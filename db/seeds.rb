# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#
# => DEV INITIA LOAD
#
dev_tech_tags_array = ["BCC","ATG-11","ANT","GIT","REST","SOAP","SPRING-BOOT","SPRING-WEB","JSF 1.2","JSTL","MYSQL","ORACLE","WEBLOGIC","REDIS","MONGO-DB","SVN","JMS"]
dev_skills = { "Java &amp; J2E" => 96, "Javascript &amp; jQuery" => 70, "Databases" => 60, "Ruby on Rails" => 40, "ATG &amp; ENDECA" => 50}

def load_tech_tags(tech_tag, env)
  if (!tech_tag.nil? && !tech_tag.empty?)
    cont = 0
    tech_tag.each{ |t|
      tag = TechTag.find_by(:name => t.upcase)
      if (tag.nil?)
        puts "Creating techtag #{t} in #{env}:0"
        tag = TechTag.new
        tag.name = t.upcase
        tag.active = true
        if (tag.valid?)
            tag.save
            cont = cont + 1
        end
      else
        puts "Tech tag #{t} exist"
      end
    }
    puts "Was created #{cont} tech tags in #{env} :)"
  end
end

def load_skills(skills, env)
  if (!skills.nil? && !skills.empty?)
    cont = 0
    skills.each{ |k, v|
      skill = Skill.find_by(:name => k.capitalize)
      if (skill.nil?)
        puts "Creating skill #{k} level #{v} in #{env} :0"
        skill = Skill.new
        skill.name = k.capitalize
        skill.level = v
        if (skill.valid?)
            skill.save
            cont = cont + 1
        else
          puts "Skill #{k} level #{v} invalid :("
        end
      else
        puts "Skill #{k} level #{v} exist"
      end
    }
    puts "Was created #{cont} skills in #{env} :)"
  end
end



if Rails.env.development?
  load_tech_tags(dev_tech_tags_array, "development")
  load_skills(dev_skills, "development")
end
