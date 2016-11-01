require 'json'
class BaseApiController < ApplicationController

	before_action :parse_request#, :authenticate_user_from_token!

  private
=begin
       def authenticate_user_from_token!
         if !@json['api_token']
           render nothing: true, status: :unauthorized
         else
           @user = nil
           User.find_each do |u|
             if Devise.secure_compare(u.api_token, @json['api_token'])
               @user = u
             end
           end
         end
       end
=end
  def parse_request
    Rails.logger.debug "Request body #{request.body.read}"
    Rails.logger.debug "Request params #{request.params}"
    if !request.params.except(:action, :controller).nil? && !request.params.except(:action, :controller).empty?
      Rails.logger.debug "Valid request->"
      Rails.logger.debug "Parsing json ->"
      @json = request.params.except(:action, :controller).to_json
    end
  end
end
