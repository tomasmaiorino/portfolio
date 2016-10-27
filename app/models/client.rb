class Client < ApplicationRecord

  validates :name, :token,  :presence => { :message => "Field Required" }
  validates_uniqueness_of :token, :case_sensitive => false, :message => "duplicate token"

  has_many :companies
end
