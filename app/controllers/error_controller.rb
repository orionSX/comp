class ErrorController < ApplicationController
  skip_before_action :check_db_connection
  def database_error
    render "database_error", status: :service_unavailable
  end
end
