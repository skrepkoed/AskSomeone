class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json{ head 401, content_type: 'text/html' }
      format.html { redirect_to root_url }
      format.js   { render exception.action }
      flash.now[:alert] = exception.message
    end
  end
end
