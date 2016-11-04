class TechTag < ApplicationRecord
  validates :name, :presence => { :message => "Field Required" }
  validates_uniqueness_of :name, :case_sensitive => false, :message => "duplicate tech",
    :if =>  Proc.new {
     |tech_tag|
     tech_tag.id.nil? ||
     TechTag.find_by(:name => tech_tag.name).nil? ||
     tech_tag.id != TechTag.find_by(:name => tech_tag.name).id
   }

end
