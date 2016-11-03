class Client < ApplicationRecord

  validates :name, :token,  :presence => { :message => "Field Required" }
  validates_uniqueness_of :token, :case_sensitive => false, :message => "duplicate token",
    :if =>  Proc.new {
     |client|
     client.id.nil? ||
     Client.find_by(:token => client.token).nil? ||
     client.id != Client.find_by(:token => client.token).id
   }
  has_many :companies
end
