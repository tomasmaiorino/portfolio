require 'json'
class BaseApiController < ApplicationController
	wrap_parameters format: [:xml]

	before_action :parse_request, :authenticate_user_from_token

	def update
    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end
		#Rails.logger.debug "Update item  id " << @json[:id] #unless @json[:id].nil?
    if (@json[:id].nil?)
      return render json:{'id':'Field required'}, status: :bad_request
    end
    create
  end

	def base_get
		obj = nil
		begin
			obj = yield
      #client = Client.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      #redirect_to :action => 'not_found'
      return head(:not_found)
    end
		if !obj.nil? then return render json:obj else return head(:not_found) end
	end

  private

	def should_check_client_token
		if !request.fullpath.include?("api/v1/client") && !request.fullpath.include?("api/v1/rating")
			if(request.method == "POST" || request.method == "PUT")
				return true
			end
		end
		return false
	end

	def authenticate_user_from_token
		if (should_check_client_token)
			if @ct.nil?
				render nothing: true, status: :unauthorized
			else
				client = Client.find_by(:token => @ct)
				if (client.nil?)
					render nothing: true, status: :unauthorized, message: "invalid ct"
				#elsif !valid_host(client.host, request.host)
				#	render nothing: true, status: :unauthorized, message: "invalid host request"
				end
			end
		end
	end

	def valid_host(client_host, host)
  	Rails.logger.debug "Request host(#{host}) - Client host(#{client_host}) "
    return client_host == host
  end

  def parse_request
		Rails.logger.debug params.inspect
    Rails.logger.debug "Request body #{request.body.read}"
    Rails.logger.debug "Request params #{request.params}"
    if !request.params.except(:action, :controller).nil? && !request.params.except(:action, :controller).empty?
      Rails.logger.debug "Valid request :)"
			if (should_check_client_token)
				Rails.logger.debug "Recovering ct ->"
				@ct = request.params[:ct]
				Rails.logger.debug "Recovering ct <-"
			end
      Rails.logger.debug "Parsing json ->"
      @json = request.params.except(:action, :controller, :ct)
		Rails.logger.debug "Parsing json <-"
	else
		Rails.logger.debug "Invalid request :("
    end
  end

	def set_headers
		allow_origins = Rails.application.config.allow_origins
		Rails.logger.info "Access-Control-Allow-Origin [#{allow_origins}]"
		headers['Access-Control-Allow-Origin'] = allow_origins
    headers['Access-Control-Expose-Headers'] = 'Etag'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = '*, x-requested-with, Content-Type, If-Modified-Since, If-None-Match'
    headers['Access-Control-Max-Age'] = '86400'
  end

end
