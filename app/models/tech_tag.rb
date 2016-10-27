class TechTag < ApplicationRecord
  validates :name, :presence => { :message => "Field Required" }
  validates_uniqueness_of :name, :case_sensitive => false, :message => "duplicate tech"
end
