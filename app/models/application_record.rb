class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.load_model_list(p_ids = [], class_name)
    return nil if p_ids.nil? || p_ids.empty?
    ret = []
    p_ids.each{ |s|
      begin
        obj = yield s
        ret << obj unless obj.nil?
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info "#{class_name} #{s} not found :("
      end
    }
    return ret
  end

  def self.load_model_list(p_ids = [], class_name, add_not_found_class)
    return nil if p_ids.nil? || p_ids.empty?
    ret = []
    p_ids.each{ |s|
      begin
        obj = yield s
        ret << obj unless obj.nil?
        ret << s if add_not_found_class && obj.nil?
      rescue ActiveRecord::RecordNotFound
        Rails.logger.info "#{class_name} #{s} not found :("
      end
    }
    return ret
  end

end
