class Skill < ApplicationRecord
  validates :name, :points, :presence => { :message => "Field Required" }
  validates_uniqueness_of :name, :case_sensitive => false, :message => "duplicate Skill name"
end
