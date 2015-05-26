class InventoryItemsController < ApplicationController

  before_action :find_inventory_item, only: [:show, :update, :destroy]

  def find_inventory_item
    @inventory_item = InventoryItem.active.find(params[:id])
  end

  def create
    @inventory_item ||= InventoryItem.new inventory_item_params
    respond_to do |format|
      format.json do
        if @inventory_item.save
          render json: @inventory_item, status: :ok
        else
          render json: { errors: @inventory_item.errors.full_messages }, status: :bad_request
        end
      end
    end
  end

  def update
    respond_to do |format|
      format.json do
        if @inventory_item.update inventory_item_params
          render json: @inventory_item, status: :ok
        else
          render json: { errors: @inventory_item.errors.full_messages }, status: :bad_request
        end
      end
    end
  end

  def destroy
    @inventory_item.destroy
    respond_to do |format|
      format.json do
        render nothing: true, status: :no_content
      end
    end
  end

  private
  def inventory_item_params
    params.require(:inventory_item).permit(:company_id, features: [:computer_name, :processor, :ram, :hard_drive, :operating_system, :log_me_in])
  end
end
