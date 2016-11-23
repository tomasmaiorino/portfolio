class ClientController < BaseApiController

  skip_before_action :verify_authenticity_token

  def create

    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    client = JSON.parse(@json.to_json, object_class: Client)

    if !client.valid?
        return render json: client.errors.to_json, status: :bad_request
    end

    client_temp = Client.find_by(:token => client.token)
    message = client_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} client with token :" << client.token

    if !client_temp.nil?
      client_temp.name = client.name
      client_temp.active = client.active
      client_temp.token = client.token
      client_temp.security_permissions = client.security_permissions
      client = client_temp
    end

    Rails.logger.debug "Lets #{message} :O "

    if client.save
      Rails.logger.debug "Client was saved :)"
      return render json:{'id':client.id}
    end
    Rails.logger.error "Error #{message} client with token: " << client.token
    return head(:bad_request)
  end

  def get
    base_get {Client.find(params[:id])}
  end

end
