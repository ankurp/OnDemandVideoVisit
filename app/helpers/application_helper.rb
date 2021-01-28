module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def avatar_path(object, options = {})
    size = options[:size] || 180
    default_image = options[:default] || "mp"
    base_url = "https://secure.gravatar.com/avatar"
    base_url_params = "?s=#{size}&d=#{default_image}"

    if object.respond_to?(:avatar) && object.avatar.attached? && object.avatar.variable?
      object.avatar.variant(resize_to_fill: [size, size, {gravity: "Center"}])
    elsif object.respond_to?(:email) && object.email
      gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
      "#{base_url}/#{gravatar_id}#{base_url_params}"
    else
      "#{base_url}/00000000000000000000000000000000#{base_url_params}"
    end
  end

  class SignedIn
    def initialize(&block)
      @block = block || lambda { |user| true }
    end

    def matches?(request)
      @request = request
      signed_in? && current_user_fulfills_additional_requirements?
    end

    private

    # @api private
    def clearance_session
      @request.env["warden"]
    end

    # @api private
    def current_user
      clearance_session.user
    end

    # @api private
    def current_user_fulfills_additional_requirements?
      @block.call current_user
    end

    # @api private
    def signed_in?
      clearance_session.present? && current_user.present?
    end
  end
end
