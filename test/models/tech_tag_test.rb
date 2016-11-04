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

    test "should_update_tech_tag" do
      tech_tag = TechTag.new
      tech_tag.name = 'JAVA'
      tech_tag.active = true
      assert tech_tag.valid?
      assert tech_tag.save
      assert tech_tag.active

      tech_tag.name = 'Java'
      assert tech_tag.valid?
      assert tech_tag.save

    end

    test "should_not_update_tech_tag" do
      tech_tag = TechTag.new
      tech_tag.name = 'JAVA'
      tech_tag.active = true
      assert tech_tag.valid?
      assert tech_tag.save
      assert tech_tag.active

      tech_tag_2 = TechTag.new
      tech_tag_2.name = 'SQL'
      tech_tag_2.active = true
      assert tech_tag_2.valid?
      assert tech_tag_2.save
      assert tech_tag_2.active

      tech_tag_2.name = 'Java'
      assert !tech_tag_2.valid?
      assert !tech_tag_2.save

    end

end
