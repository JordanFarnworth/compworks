class PurchaseOrdersController < ApplicationController

  def index
    @po = PurchaseOrder.all.paginate(page: params[:page], per_page: 10)
  end

  def show

  end

  def new
    @po ||= PurchaseOrder.new
  end

  def create
    @po = PurchaseOrder.new purchase_order_params
  end

  private
  def purchase_order_params
    params.require(:purchase_order).permit(:po_number, :vendor, :company_id, :items, :created_at, :updated_at)
  end

end
