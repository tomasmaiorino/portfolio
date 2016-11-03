require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should_not_save_skill" do
    skill = Skill.new
    assert !skill.valid?
    assert !skill.save

    skill = Skill.new
    skill.name = 'atg'
    assert !skill.valid?
    assert !skill.save

    skill = Skill.new
    skill.points = 2
    assert !skill.valid?
    assert !skill.save
  end

  test "should_not_save_skill_passing_duplicate_skill" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 2
    assert skill.save

    skill = Skill.new
    skill.name = 'atg'
    skill.points = 4
    assert !skill.valid?
    assert !skill.save

    skill = Skill.new
    skill.name = 'aTG'
    skill.points = 4
    assert !skill.valid?
    assert !skill.save

  end

  test "should_save_skill" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 2
    assert skill.valid?
    assert skill.save
  end

  test "should_update_skill" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 20
    assert skill.valid?
    assert skill.save

    skill_2 = Skill.find_by(:name => skill.name)
    assert_not_nil skill_2
    assert_equal skill.points, skill_2.points

    skill_2.points = 30
    assert skill_2.valid?
    assert skill_2.save
  end

  test "should_not_update_skill" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 20
    assert skill.valid?
    assert skill.save

    skill_2 = Skill.new
    skill_2.name = 'java'
    skill_2.points = 40
    assert skill_2.valid?
    assert skill_2.save

    skill_3 = Skill.find_by(:name => skill_2.name)
    assert_not_nil skill_3
    assert_equal skill_2.points, skill_3.points

    skill_3.name = 'atg'
    assert !skill_3.valid?
    assert !skill_3.save
  end

end
