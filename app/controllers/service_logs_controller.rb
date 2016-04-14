class ServiceLogsController < ApplicationController
  include Api::V1::ServiceLog

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

  def show
    @sl = ServiceLog.find params[:id]
    respond_to do |format|
      format.html do

      end
      format.json do
        render json: service_log_json(@sl), status: :ok
      end
    end
  end

  def index
    @paid_service_logs = ServiceLog.paid.order(created_at: :desc).active.includes(:company).paginate(page: params[:page], per_page: 15)
    @unpaid_service_logs = ServiceLog.unpaid.order(created_at: :desc).active.includes(:company).paginate(page: params[:page], per_page: 15)
  end

  def mark_as_paid
    @sl = ServiceLog.find params[:id]
    @sl.mark_as_paid!
    respond_to do |format|
      format.json do
        render json: service_log_json(@sl), status: :ok
      end
    end
  end

  def mark_as_unpaid
    @sl = ServiceLog.find params[:id]
    @sl.mark_as_unpaid!
    respond_to do |format|
      format.json do
        render json: service_log_json(@sl), status: :ok
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
        render json: {success: "Service Log deleted"}, status: :ok
      end
    end
  end


  private
  def service_log_params
    params.require(:service_log).permit(:date, :length, :service_preformed, :notes, :company_id, :state, :payment)
  end
end
