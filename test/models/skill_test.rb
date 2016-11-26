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

  test "should_not_save_skill_not_points_as_text" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = '2e'
    assert !skill.valid?
    assert !skill.save
  end

  test "should_not_save_skill_passing_invalid_points" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 101
    assert !skill.valid?
    assert !skill.save

    skill.points = -1
    assert !skill.valid?
    assert !skill.save

    skill.points = 100
    assert skill.valid?
    assert skill.save
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

  test "should_load_skills_by_class" do
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

    skill_3 = Skill.new
    skill_3.name = 'java'

    skill_4 = Skill.new
    skill_4.name = 'atg'

    assert_nil skill_4.id
    assert_nil skill_3.id

    skills_in = [skill_3, skill_4]
    skills = Skill.load_skills(skills_in)

    assert_not_empty skills
    assert_equal skills_in.size, skills.size
    assert_not_nil skills[0].id
    assert_not_nil skills[1].id
    assert_equal skills[0].name, skill_3.name
    assert_equal skills[1].name, skill_4.name
    assert_equal skill.id, skills[1].id
    assert_equal skill_2.id, skills[0].id

  end

  test "should_load_not_all_skills_by_class" do
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

    skill_3 = Skill.new
    skill_3.name = 'java'

    skill_4 = Skill.new
    skill_4.name = 'sql'

    assert_nil skill_4.id
    assert_nil skill_3.id

    skills_in = [skill_3, skill_4]
    skills = Skill.load_skills(skills_in)

    assert_not_empty skills
    assert_equal skills_in.size - 1, skills.size
    assert_not_nil skills[0].id
    assert_equal skills[0].name, skill_3.name
    assert_equal skill_2.id, skills[0].id

  end

  test "should_load_and_add_not_persisted_skills_by_class" do
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

    skill_3 = Skill.new
    skill_3.name = 'java'

    skill_4 = Skill.new
    skill_4.name = 'sql'

    assert_nil skill_4.id
    assert_nil skill_3.id

    skills_in = [skill_3, skill_4]
    skills = Skill.load_skills(skills_in, true)

    assert_not_empty skills
    assert_equal skills_in.size, skills.size
    assert_not_nil skills[0].id
    assert_equal skill_2.id, skills[0].id
    assert_equal skill_3.name, skills[0].name
    assert_equal skill_4.name, skills[1].name
    assert_nil skills[1].id
  end

  test "should_load_skills_by_id" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 20
    assert skill.valid?
    assert skill.save
    id_1 = skill.id

    skill = Skill.new
    skill.name = 'java'
    skill.points = 49
    assert skill.valid?
    assert skill.save
    id_2 = skill.id

    skills_in = [id_1, id_2]
    skills = Skill.load_skills(skills_in)

    assert_not_empty skills
    assert_equal skills_in.size, skills.size
    assert_equal skills_in[0], skills[0].id
    assert_equal skills_in[1], skills[1].id

  end

  test "should_not_load_al_skills_by_id" do
    skill = Skill.new
    skill.name = 'atg'
    skill.points = 20
    assert skill.valid?
    assert skill.save
    id_1 = skill.id

    skills_in = [id_1, 3]
    skills = Skill.load_skills(skills_in)

    assert_not_empty skills
    assert_equal skills_in.size - 1, skills.size
    assert_equal skills_in[0], skills[0].id

  end


  test "should_not_load_skills_by_class" do
    skill = Skill.new
    skill.name = 'sql'

    skill_2 = Skill.new
    skill_2.name = 'atg'

    assert_nil skill.id
    assert_nil skill_2.id

    skills_in = [skill, skill_2]
    skills = Skill.load_skills(skills_in)

    assert_empty skills
  end

  test "should_load_skills_by_name" do
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

    skill_3  = 'java'
    skill_4  = 'atg'

    skills_in = [skill_3, skill_4]
    skills = Skill.load_skills(skills_in)

    assert_not_empty skills
    assert_equal skills_in.size, skills.size
    assert_not_nil skills[0].id
    assert_not_nil skills[1].id
    assert_equal skills[1], skill
    assert_equal skills[0], skill_2
    assert_equal skills[0].name, skill_3
    assert_equal skills[1].name, skill_4
    assert_equal skill.id, skills[1].id
    assert_equal skill_2.id, skills[0].id

  end

  test "should_load_not_all_skills_by_name" do
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

    skill_3  = 'java'
    skill_4  = 'sql'

    skills_in = [skill_3, skill_4]
    skills = Skill.load_skills(skills_in)

    assert_not_empty skills
    assert_equal skills_in.size - 1, skills.size
    assert_not_nil skills[0].id
    assert_equal skills[0].name, skill_3
    assert_equal skill_2.id, skills[0].id

  end

  test "should_not_load_skills_by_name" do
    skill = 'sql'
    skill_2 = 'atg'

    skills_in = [skill, skill_2]
    skills = Skill.load_skills(skills_in)

    assert_empty skills
  end


end
