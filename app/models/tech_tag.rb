class TechTag < ApplicationRecord
  validates :name, :presence => { :message => "Field Required" }
  validates_uniqueness_of :name, :case_sensitive => false, :message => "duplicate tech",
    :if =>  Proc.new {
     |tech_tag|
     tech_tag.id.nil? ||
     TechTag.find_by(:name => tech_tag.name).nil? ||
     tech_tag.id != TechTag.find_by(:name => tech_tag.name).id
   }

   def self.load_tech_tags(p_tech_tags = [], add_not_found_class = false)
     return nil if p_tech_tags.nil? || p_tech_tags.empty?
     is_string = p_tech_tags[0].kind_of? String
      load_model_list(p_tech_tags, 'TechTag', false) {|s| TechTag.find_by(:name => is_string == true ? s : s.name)}
   end
end
