class CompanyController < BaseApiController

  skip_before_action :verify_authenticity_token

  @my_class = Company

  def parse_json(value, clazz)
    Rails.logger.debug "Parsing #{clazz.to_s}: #{value}"
    obj = nil
    begin
    obj =  JSON.parse(value.to_json, object_class: clazz)
    rescue  Exception => e
      Rails.logger.error e.message
      return nil
    end
    return obj
  end

  def create

    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    company = @json#JSON.parse( @json, symbolize_names: true)

    #check if the client id was informed
    client_id = nil
    client = nil
    if (!company[:client_id].blank?)
      begin
        client = Client.find(company[:client_id])
      rescue ActiveRecord::RecordNotFound
        return render json:{'client_id': 'client not found'}, :status => :bad_request
      end
    end

    final_company = Company.new

    final_company.client = client
    #
    # => skill block
    #
    skills = configure_skills(company)

    final_company.skills = skills unless skills.nil? || skills.empty?

    Rails.logger.debug "Updating company skills" unless final_company.skills.nil? || final_company.skills.empty?

    final_company.name = company[:name]
    final_company.token = company[:token]
    final_company.email = company[:email]
    final_company.manager_name = company[:manager_name]
    final_company.active = company[:active]
    final_company.main_color = company[:main_color]
    final_company.id = company[:id]

    if !final_company.valid?
        return render json: final_company.errors.to_json, status: :bad_request
    end

    company_temp = if final_company.id.nil? then Company.find_by(:token => final_company.token) else Company.find_by(:id => final_company.id) end
    message = company_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} company with token :" << final_company.token

    if !company_temp.nil?
      company_temp.skills = final_company.skills unless final_company.skills.nil? || final_company.skills.empty?
      company_temp.name = final_company.name
      company_temp.token = final_company.token
      company_temp.manager_name = final_company.manager_name
      company_temp.email = final_company.email
      company_temp.main_color = final_company.main_color
      company_temp.active = final_company.active
      company_temp.client = final_company.client
      final_company = company_temp
    end

    Rails.logger.debug "Lets #{message} :O "

    if final_company.save
      Rails.logger.debug "Company was saved :)"
      return render json:{'id':final_company.id}
    end
    Rails.logger.error "Error #{message} company with token: " << final_company.token
    return head(:bad_request)
  end

  def configure_skills(company)
    return nil if company.nil? || company[:skills].blank?
    Rails.logger.debug "Lets load skills :"
    return Skill.load_skills(company[:skills])
  end

  def base_get
    obj = nil
    begin
      obj = yield
    rescue ActiveRecord::RecordNotFound
      return head(:not_found)
    end

    if !obj.nil? then return render :json => obj, :include => {
      :skills => {:only => [:name, :level]}, :projects => {
        :only =>
        [:name,
        :img,
        :link_img,
        :summary,
        :description,
        :improvements,
        :time_spent,
        :future_project,
        :project_date
        ],
        :include => {:tech_tags => {:only => :name}}
      }
      }, :except => [:created_at, :updated_at] else return head(:not_found) end
  end

  def get
    #base_get{Company.find_by(:token => params[:token])}
    token  = params[:token]
    base_get{Company.includes(:projects).where(:projects => {active: true}, :token => token)[0]}
  end

  def get_company_client
    client = Client.find_by(:id => params[:client_id], :active => true)
    return head(:not_found) if client.nil?
    base_get{Company.where(:client => client, :active => true).all}
  end

  def get_company_skills
    company = Company.find_by(:token => params[:token])
    return head(:not_found) if company.nil? || company.skills.nil? || company.skills.empty?
    render :json => {:skills => company.skills.as_json(only: [:name, :level])}
  end


  def get_projects_tech_tags_by_company
    Rails.logger.debug "Searching tech tags for this token #{params[:token]}"
    companies = Company.includes(:projects).where(:projects => {active: true}, :token => params[:token])
    return head(:not_found) if companies.nil? || companies.empty?
    tech_tags = []
    companies[0].projects.each{|p|
      p.tech_tags.each{|t|
        tech_tags << t.name
      }
    }
    return head(:not_found) if tech_tags.empty?
    return render json:{'tech_tags':tech_tags.uniq}
  end

end
