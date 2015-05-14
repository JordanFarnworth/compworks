class CompaniesController < ApplicationController
  include Api::V1::Company
  include Api::V1::ServiceLog
  include Api::V1::InventoryItem

  before_action :find_companies, only: [:index]
  before_action :find_company, only: [:show, :edit, :service_logs, :inventory_items]

  def index
    if params[:search_term]
      t = params[:search_term]
      @companies = @companies.where('name LIKE ?', "%#{t}%")
    end
    respond_to do |format|
      format.json do
        render json: companies_json(@companies), status: :ok
      end
      format.html do
      end
    end
  end

  def show
    respond_to do |format|
      format.json do
        render json: company_json(@company), status: :ok
      end
      format.html do
      end
    end
  end

  def new
    @company ||= Company.new
  end

  def create
    @company ||= Company.new
    respond_to do |format|
      format.html do
        if @company.save
          flash[:success] = 'Company created!'
          redirect_to @company
        else
          render 'new'
        end
      end
      format.json do
        if @company.save
          render json: @company, status: :ok
        else
          render json: { errors: @company.errors.full_messages }, status: :bad_request
        end
      end
    end
  end

  def find_company
    @company = Company.find params[:id] || params[:company_id]
    @inventory_items = @company.inventory_items
    @service_logs = @company.service_logs
  end

  def find_companies
    @companies = Company.all.active
  end

  def service_logs
    respond_to do |format|
      format.json do
        render json: service_logs_json(@service_logs), status: :ok
      end
    end
  end

  def inventory_items
    respond_to do |format|
      format.json do
        render json: inventory_items_json(@inventory_items), status: :ok
      end
    end
  end
end
