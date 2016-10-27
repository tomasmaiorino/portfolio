class Company < ApplicationRecord

  belongs_to :client
  has_many :skill
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :skills

  validates :name, :token,  :presence => { :message => "Field Required" }
  validates_uniqueness_of :token, :case_sensitive => false, :message => "duplicate token"
  validates_presence_of :client


end
