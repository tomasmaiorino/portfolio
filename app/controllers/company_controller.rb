class CompanyController < BaseApiController

  @my_class = Company

  before_action :before_create, only: [:create]

  def before_create
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
        client = Client.find(company['client_id'])
      rescue ActiveRecord::RecordNotFound
        return render json:{'client_id': 'client not found'}, :status => :bad_request
      end
    end

    final_company = Company.new

    final_company.client = if client.nil? then configure_client(company) else client end
    #
    # => skill block
    #

    final_company.name = company[:name]
    final_company.token = company[:token]

    if !final_company.valid?
        return render json: final_company.errors.to_json, status: :bad_request
    end

  end

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

    company = JSON.parse( @json, object_class: @my_class)

    company_temp = Company.find_by(:token => company.token)
    message = company_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} company with token :" << company.token

    if !company_temp.nil?
      company_temp.companies = company.companies
      company_temp.name = company.name
      company_temp.active = company.active
      company_temp.security_permissions = company.security_permissions
      company = company_temp
    end

    if company.save
      Rails.logger.debug "Company was saved :)"
      return render json:{'id':company.id}
    end
    Rails.logger.error "Error #{message} company with token: " << company.token
    return head(:bad_request)
  end

  def configure_client(company)
      client = parse_json(company[:client], Client)
      return client if client.nil? || !client.valid?
      #check if the client exist
      client_temp = Client.find_by(:token => client.token)
      if (client_temp.nil?)
        Rails.logger.info("Creating client, name(#{client.name}), token(#{client.token})")
        client = client unless !client.save
      else
        client = client_temp
      end
      return client
  end

end
