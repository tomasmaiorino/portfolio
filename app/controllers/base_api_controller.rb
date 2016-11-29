require 'json'
class BaseApiController < ApplicationController

	before_action :parse_request, :authenticate_user_from_token

=begin
	def pre_create(clazz)

		if (@json.nil?)
			Rails.logger.debug "Json nil :("
			return render nothing: true, status: :bad_request
		end

		obj = JSON.parse( @json, object_class: clazz)

		if !obj.valid?
				return render json: obj.errors.to_json, status: :bad_request
		end

		return obj

	end
=end

	def update
    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end
		Rails.logger.debug "Update item  id " << @json["id"] unless @json["id"].nil?
    if (@json["id"].nil?)
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

   def authenticate_user_from_token
		 if !request.fullpath.include?("api/v1/client")
			 if(request.method == "POST" || request.method == "PUT")
		     if @ct.nil?
		       render nothing: true, status: :unauthorized
		     else
					 client = Client.find_by(:token => @ct)
					 if (client.nil?)
						 render nothing: true, status: :unauthorized
					 end
		     end
			 end
		 end
   end

  def parse_request
		Rails.logger.debug params.inspect
    Rails.logger.debug "Request body #{request.body.read}"
    Rails.logger.debug "Request params #{request.params}"
    if !request.params.except(:action, :controller).nil? && !request.params.except(:action, :controller).empty?
      Rails.logger.debug "Valid request :)"
      Rails.logger.debug "Parsing json ->"
			#@ct = request.params[:ct]
      @json = request.params.except(:action, :controller)
			Rails.logger.debug "Parsing json <-"
		else
			Rails.logger.debug "Invalid request :("
    end
  end
end
