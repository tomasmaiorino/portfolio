require 'test_helper'

class TechTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
    test "should_not_save_tech_tag" do
      tech_tag = TechTag.new
      assert !tech_tag.valid?
      assert !tech_tag.save
    end

    test "should_not_save_tech_tag_passing_duplicate_tech_tag" do
      tech_tag = TechTag.new
      tech_tag.name = 'BCC'
      assert tech_tag.save

      tech_tag = TechTag.new
      tech_tag.name = 'bCC'
      assert !tech_tag.valid?
      assert !tech_tag.save
    end

    test "should_save_tech_tag" do
      tech_tag = TechTag.new
      tech_tag.name = 'JAVA'
      tech_tag.active = true
      assert tech_tag.valid?
      assert tech_tag.save
      assert tech_tag.active
    end

end
