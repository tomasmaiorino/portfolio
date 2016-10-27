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

end
