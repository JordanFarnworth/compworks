class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: 'api_request?'

  before_action :set_current_user

 def api_request?
   request.format.symbol == :json
 end

 before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
 end


  def set_current_user
    if api_request?
      if request.headers['Authorization'] && request.headers['Authorization'].match(/Bearer (.+)/)
        token = request.headers['Authorization'].match(/Bearer (.+)/)[1]
      end
      token ||= params[:access_token]
      @current_user ||= User.active.joins("LEFT JOIN api_keys AS a on a.user_id = users.id").where("a.key = ? AND a.expires_at > ?", SecurityHelper.sha_hash(token), Time.now).first if token
    end
    if cookie_type[:_cworks_key]
      @current_user ||= User.active.joins("LEFT JOIN login_sessions AS l on l.user_id = users.id").where("l.key = ? AND l.expires_at > ?", SecurityHelper.sha_hash(cookie_type[:_cworks_key]), Time.now).first
    end
  end

  def current_user
    @current_user
  end

  def cookie_type
    Rails.env == 'production' ? cookies.encrypted : cookies
  end

  def logged_in?
    !!@current_user
  end

  def render_unauthorized
    respond_to do |format|
      format.html do
        flash[:error] = 'Oops, you\'re not authorized to perform that action'
        redirect_to :root
      end
      format.json do
        render json: { 'message' => 'Oops, looks like you\'re not authorized to perform that action' }, status: 401
      end
    end
  end


  private :set_current_user
  helper_method :logged_in?
end
