class ProjectController < ApplicationController

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

    project.delete(:companies) unless !project.has_key?(:companies)
    project.delete(:tech_tags) unless !project.has_key?(:tech_tags)

    project = JSON.parse(@json.to_json, object_class: Project)
    if !project.valid?
        return render json: project.errors.to_json, status: :bad_request
    end

    project_temp = Project.find(project.id)
    message = project_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} project with token :" << project.token

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
        project_temp.companies = companies unless companies.nil? || companies.empty?
        project_temp.tech_tags = tech_tags unless tech_tags.nil? || tech_tags.empty?

        project = project_temp
    end

    if project.save
      Rails.logger.debug "Project was saved :)"
      return render json:{'id':project.id}
    end
    Rails.logger.error "Error #{message} project with token: " << project.token
    return head(:bad_request)
  end

  def get
    base_get {Project.find(params[:id])}
  end

end
