class ProjectController < BaseApiController

  after_action :set_headers

  skip_before_action :verify_authenticity_token

  def create

    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    project_req = @json#JSON.parse(@json.to_json, object_class: Project)

    #
    # => Company block
    #
    companies = configure_companies(project_req)

    #
    # => Tech Tags block
    #
    tech_tags = configure_tech_tags(project_req)

    project_req.delete(:companies) unless !project_req.has_key?(:companies)
    project_req.delete(:tech_tags) unless !project_req.has_key?(:tech_tags)

    project = JSON.parse(project_req.to_json, object_class: Project)

    if !project.valid?
        return render json: project.errors.to_json, status: :bad_request
    end

    project_temp = Project.find_by_id(project.id)
    message = project_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} project with name :" << project.name

    if !project_temp.nil?

        project_temp.name = project.name
        project_temp.img = project.img
        project_temp.link_img = project.link_img
        project_temp.summary = project.summary
        project_temp.description = project.description
        project_temp.improvements = project.improvements
        project_temp.time_spent = project.time_spent
        project_temp.language = project.language
        project_temp.active = project.active
        project_temp.future_project = project.future_project
        project_temp.project_date = project.project_date

        project = project_temp
    end

    project.companies = companies unless companies.nil? || companies.empty?
    project.tech_tags = tech_tags unless tech_tags.nil? || tech_tags.empty?

    if project.save
      Rails.logger.debug "Project was saved :)"
      return render json:{'id':project.id}
    end
    Rails.logger.error "Error #{message} project with token: " << project.token
    return head(:bad_request)
  end

  def base_get
    obj = nil
    begin
      obj = yield
    rescue ActiveRecord::RecordNotFound
      return head(:not_found)
    end
    if !obj.nil? then return render :json => obj,
        :include => {:tech_tags => {:only => :name}}, :except => [:created_at, :language]
       else return head(:not_found) end
  end

  def get
    base_get {Project.find(params[:id])}
  end

  def configure_companies(project)
    return nil if project.nil? || project[:companies].blank?
    return Company.where(:id => project[:companies])
  end

  def configure_tech_tags(project)
    return nil if project.nil? || project[:tech_tags].blank?
    return TechTag.where(:id => project[:tech_tags])
  end

end
