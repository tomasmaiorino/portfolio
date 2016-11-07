class CompanyController < BaseApiController

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

    company = JSON.parse( @json, symbolize_names: true)

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

    final_company.skills = skills unless skills.empty?
    final_company.name = company[:name]
    final_company.token = company[:token]

    if !final_company.valid?
        return render json: final_company.errors.to_json, status: :bad_request
    end

    company_temp = Company.find_by(:token => final_company.token)
    message = company_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} company with token :" << final_company.token

    if !company_temp.nil?
      company_temp.skills = final_company.skills unless final_company.skills.nil? || final_company.skills.empty?
      company_temp.name = final_company.name
      company_temp.token = final_company.token
      company_temp.client = final_company.client
      final_company = company_temp
    end

    if final_company.save
      Rails.logger.debug "Company was saved :)"
      return render json:{'id':final_company.id}
    end
    Rails.logger.error "Error #{message} company with token: " << final_company.token
    return head(:bad_request)
  end

  def configure_skills(company)
    return nil if company.nil? || company[:skills].blank?
    return Skill.load_skills(company[:skills])
  end

  def get
    obj = nil
		begin
		  obj = Company.find_by(:token => params[:token])
    rescue ActiveRecord::RecordNotFound
      return head(:not_found)
    end
    if !obj.nil? then return render :json => obj, :include => [:skills => {:only => [:name, :points]}] else return head(:not_found) end
  end

end
