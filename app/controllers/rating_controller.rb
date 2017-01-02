class RatingController < BaseApiController

  skip_before_action :verify_authenticity_token

  def create

    if (@json.nil?)
      Rails.logger.debug "Json nil :("
      return render nothing: true, status: :bad_request
    end

    rating_req = @json

    company_id = rating_req[:cp]
    rating_req.delete(:cp)

    rating = JSON.parse(rating_req.to_json, object_class: Rating)

    if !rating.valid?
        return render json: rating.errors.to_json, status: :bad_request
    end

    if !company_id.blank?
        company = Company.find_by(:token => company_id)
        Rails.logger.debug "Invalid company informed: #{company_id}"
        rating.company = company unless company.nil?
    end

    if rating.save
      Rails.logger.debug "Rating was saved :)"
      return render json:{'id':rating.id}
    end
    Rails.logger.error "Error #{message} rating"
    return head(:bad_request)

  end

  def base_get
    obj = nil
    begin
      obj = yield
    rescue ActiveRecord::RecordNotFound
      return head(:not_found)
    end

    if !obj.blank? then return render :json => obj, :except => [:created_at, :updated_at, :company] else return head(:not_found) end
  end

  def get
    token  = params[:token]
    base_get{Rating.includes(:company).where('token = ?', token).references(:companies)}
  end

end
