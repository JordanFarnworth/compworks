class ServiceLogsController < ApplicationController

  before_action :find_service_log, only: [:show, :update, :destroy]

  def find_service_log
    @service_log = ServiceLog.active.find(params[:id])
  end

  def update
    respond_to do |format|
      format.json do
        if @service_log.update service_log_params
          render json: @service_log, status: :ok
        end
      end
    end
  end

  def create
    @service_log ||= ServiceLog.new service_log_params
    respond_to do |format|
      format.json do
        if @service_log.save
          render json: @service_log, status: :ok
        else
          render json: { errors: @service_log.errors.full_messages }, status: :bad_request
        end
      end
    end
  end

  def destroy
    @service_log.destroy
    respond_to do |format|
      format.json do
        render nothing: true, status: :no_content
      end
    end
  end


  private
  def service_log_params
    params.require(:service_log).permit(:date, :length, :service_preformed, :notes, :company_id, :state)
  end
end
