class SkillController < BaseApiController

  skip_before_action :verify_authenticity_token

  after_action :set_headers
  
  def create

    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    skill = JSON.parse( @json.to_json, object_class: Skill)

    if !skill.valid?
      return render json: skill.errors.to_json, status: :bad_request
    end

    skill_temp = if !skill.id.nil? then Skill.find_by(:id => skill.id) else Skill.find_by(:name => skill.name) end

    message = skill_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} skill with name :" << skill.name

    if !skill_temp.nil?
      skill_temp.name = skill.name
      skill_temp.level = skill.level
      skill = skill_temp
    end

    Rails.logger.debug "Lets #{message} :O "

    if skill.save
      Rails.logger.debug "Skill was saved :)"
      return render json:{'id':skill.id}
    end

    Rails.logger.error "Error #{message} skill with name: " << skill.name
    return head(:internal_server_error)
  end

  def get_name
    base_get {Skill.find_by(:name => params[:name])}
  end

  def get
    Rails.logger.debug "Searching skill by id #{params[:id]}"
    base_get {Skill.find(params[:id])}
  end

  def get_all
    Rails.logger.debug "Searching all skills"
    base_get {Skill.all}
  end

end
