class TechTagController < BaseApiController

  after_action :set_headers

  skip_before_action :verify_authenticity_token

  def create

    if (@json.nil? || @json.empty?)
			Rails.logger.debug "Json nil or empty :("
			return render nothing: true, status: :bad_request
		end

		tech_tag = JSON.parse( @json.to_json, object_class: TechTag)

		if !tech_tag.valid?
				return render json: tech_tag.errors.to_json, status: :bad_request
		end

    tech_tag_temp = if !tech_tag.id.nil? then TechTag.find_by(:id => tech_tag.id) else TechTag.find_by(:name => tech_tag.name) end

    message = tech_tag_temp.nil? ? "Creating" : "Updating"

    Rails.logger.info "#{message} tech_tag with name :" << tech_tag.name

    if !tech_tag_temp.nil?
      tech_tag_temp.name = tech_tag.name
      tech_tag = tech_tag_temp
    end

    Rails.logger.debug "Lets #{message} :O "

    if tech_tag.save
      Rails.logger.debug "Tech_tag was saved :)"
      return render json:{'id':tech_tag.id}
    end
    Rails.logger.error "Error #{message} tech_tag with token: " << tech_tag.name
    return head(:bad_request)

  end

  def get
    base_get {TechTag.find(params[:id])}
  end

  def get_all
    base_get {TechTag.all}
  end


  def get_name
    base_get {TechTag.find_by(:name => params[:name])}
  end

end
