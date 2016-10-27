class Project < ApplicationRecord

  has_and_belongs_to_many :companies
  has_and_belongs_to_many :teck_tags

  validates :name, :img, :link_img, :summary, :project_date, :time_spent, :presence => { :message => "Field Required" }
end
