class DashboardController < ApplicationController

  skip_before_action :check_session

  def index

  end

  def admin_dashboard
  end

end
