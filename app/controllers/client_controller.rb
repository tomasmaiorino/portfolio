class ClientController < BaseApiController

  def create
    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    client = JSON.parse( @json, object_class: Client)

    if !client.valid?
        return render json: client.errors.to_json, status: :bad_request
    end
    client_temp = Client.find_by(:token => client.token)
    message = client_temp.blank? ? "Creating" : "Updating"

    Rails.logger.info "#{message} client with token :" << client.token

    client.id = client_temp.id unless client_temp.blank?

    if client.save
      Rails.logger.debug "Client was saved :)"
      #return head(:success)
      #render
      return render json:{'id':client.id}
      #render body: nil, status: :success
    end

    Rails.logger.error "Error #{message} client with token: " << client.token
    #return head(:error)
    return head(:bad_request)
    #render
    #return render nothing: true, status: :error
     #render body: nil, status: :error
  end
end
