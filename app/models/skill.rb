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

end
