class Company < ApplicationRecord

  belongs_to :client
  has_many :skills
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :skills

  validates :name, :token,  :presence => { :message => "Field Required" }
  validates_uniqueness_of :token, :case_sensitive => false, :message => "duplicate token",
    :if =>  Proc.new {
     |company|
     company.id.nil? ||
     Company.find_by(:token => company.token).nil? ||
     company.id != Company.find_by(:token => company.token).id
   }

  validates_presence_of :client

  def delete_skill(skill_name = [], del = false)
    skill_name.each {|s|
      skill = Skill.find_by(:name => s)
      skills.delete(skill.id) unless skill.nil?
      skill.delete unless !del
    }
  end

  def contains_skill(skill_name)
    if !skills.nil? || !skill_name.blank?
      ind = skills.to_a.index{|x| x.name == skill_name}
      return !ind.nil? && ind >= 0
    end
    return false
  end
=begin
  def self.load_companies(p_companies = [])
    load_model_list(p_companies, 'Company', false) {|s| Company.find(s)}
  end
=end
end
