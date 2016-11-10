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

    test "should_load_tech_tags" do
      tech_tag = TechTag.new
      tech_tag.name = 'JAVA'
      tech_tag.active = true
      assert tech_tag.valid?
      assert tech_tag.save
      assert tech_tag.active
      tech_tag_id = tech_tag.id

      tech_tag = TechTag.new
      tech_tag.name = 'ORACLE'
      tech_tag.active = true
      assert tech_tag.valid?
      assert tech_tag.save
      assert tech_tag.active

      tech_tags = TechTag.load_tech_tags([tech_tag_id, tech_tag.id], false, true)
      assert_not_nil tech_tags
      assert_not_empty tech_tags
      assert_equal 2, tech_tags.size
      assert_equal tech_tag_id, tech_tags[0].id
      assert_equal tech_tag.name, tech_tags[1].name
      assert_equal tech_tag.id, tech_tags[1].id

    end

    test "should_load_tech_tags_by_name" do
      tech_tag = TechTag.new
      tech_tag.name = 'JAVA'
      tech_tag.active = true
      assert tech_tag.valid?
      assert tech_tag.save
      assert tech_tag.active
      tech_tag_id = tech_tag.id
      name_1 = tech_tag.name

      tech_tag = TechTag.new
      tech_tag.name = 'ORACLE'
      tech_tag.active = true
      assert tech_tag.valid?
      assert tech_tag.save
      assert tech_tag.active
      name_2 = tech_tag.name


      tech_tags = TechTag.load_tech_tags([name_1, name_2])
      assert_not_nil tech_tags
      assert_not_empty tech_tags
      assert_equal 2, tech_tags.size
      assert_equal tech_tag_id, tech_tags[0].id
      assert_equal tech_tag.name, tech_tags[1].name
      assert_equal tech_tag.id, tech_tags[1].id

    end


    test "should_not_load_tech_tags" do
      assert_nil TechTag.load_tech_tags([])
      assert_nil TechTag.load_tech_tags(nil)
    end

    test "should_load_tech_tags_passing_invalid_id" do
      assert_empty TechTag.load_tech_tags([3322])
    end

end
