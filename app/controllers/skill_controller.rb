class SkillController < BaseApiController

  def create

    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    skill = JSON.parse( @json.to_json, object_class: Skill)

    if !skill.valid?
      return render json: skill.errors.to_json, status: :bad_request
    end

    skill_temp = Skill.find_by(:name => skill.name)
    message = skill_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} skill with name :" << skill.name

    if !skill_temp.nil?
      skill_temp.name = skill_temp.name
      skill_temp.points = skill.points
      skill = skill_temp
    end

    if skill.save
      Rails.logger.debug "Skill was saved :)"
      return render json:{'id':skill.id}
    end

    Rails.logger.error "Error #{message} skill with name: " << skill.name
    return head(:bad_request)
  end

  def get_name
    base_get {Skill.find_by(:name => params[:name])}
  end

  def get
    base_get {Skill.find(params[:id])}
  end

end
