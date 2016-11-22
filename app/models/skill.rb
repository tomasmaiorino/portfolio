class Skill < ApplicationRecord
  validates :name, :points, :presence => { :message => "Field Required" }
  validates :points, numericality: { only_integer: true,
    less_than_or_equal_to: 100,
    greater_than_or_equal_to: 0
   }

  validates_uniqueness_of :name, :case_sensitive => false, :message => "duplicate Skill name",
    :if =>  Proc.new {
     |skill|
     skill.id.nil? ||
     Skill.find_by(:name => skill.name).nil? ||
     skill.id != Skill.find_by(:name => skill.name).id
   }

   def self.load_skills(p_skills = [], add_not_found_class = false)
     return nil if p_skills.nil? || p_skills.empty?
     is_string = p_skills[0].kind_of? String
     load_model_list(p_skills, 'Skill', add_not_found_class) {|s| Skill.find_by(:name => is_string == true ? s : s.name)}
   end
end
