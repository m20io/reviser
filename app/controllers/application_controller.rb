class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :init_proofreading_agency

  def init_proofreading_agency
    @proofreading_agency = THE_PROOFREADING_AGENCY
  end
end
