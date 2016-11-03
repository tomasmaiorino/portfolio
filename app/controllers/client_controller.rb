class ClientController < BaseApiController

  def create

    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    puts 'parsing json to class->'
    client = JSON.parse( @json, object_class: Client)
    puts 'parsing json to class->'
    if !client.valid?
        return render json: client.errors.to_json, status: :bad_request
    end

    client_temp = Client.find_by(:token => client.token)
    message = client_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} client with token :" << client.token

    if !client_temp.nil?
      client_temp.companies = client.companies
      client_temp.name = client.name
      client_temp.active = client.active
      client_temp.security_permissions = client.security_permissions
      client = client_temp
    end

    if client.save
      Rails.logger.debug "Client was saved :)"
      return render json:{'id':client.id}
    end
    Rails.logger.error "Error #{message} client with token: " << client.token
    return head(:bad_request)
  end

  def update
    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end
    if (@json['id'].nil?)
      return render json:{'id':'Field required'}, status: :bad_request
    end
    create
  end

  def get
    begin
      client = Client.find(params[:id])
    rescue ActiveResource::ResourceNotFound
      redirect_to :action => 'not_found'
    end
    return render json:client
  end
end
