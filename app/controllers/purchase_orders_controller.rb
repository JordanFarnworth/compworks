class PurchaseOrdersController < ApplicationController

  def index
    @paid_pos = PurchaseOrder.all.paid.paginate(page: params[:page], per_page: 15)
    @unpaid_pos = PurchaseOrder.all.unpaid.paginate(page: params[:page], per_page: 15)
  end

  def show
    @po = PurchaseOrder.find params[:id]
  end

  def new
    @po ||= PurchaseOrder.new
  end

  def create
    po_params = purchase_order_params.tap {|at| at.delete("item")}
    po_params = po_params.tap {|at| at.delete("vendor")}
    @purchase_order = PurchaseOrder.new po_params
    @item = Item.find_or_create_by(name: purchase_order_params["item"])
    @vendor = Vendor.find_or_create_by(name: purchase_order_params["vendor"])
    if @purchase_order.save
      @ij = ItemJoiner.create!(item_id: @item.id, purchase_order_id: @purchase_order.id)
      @ij.save
      @pov = PurchaseOrderVendor.create!(vendor_id: @vendor.id, purchase_order_id: @purchase_order.id)
      @pov.save
      render json: @purchase_order, status: :ok
    else
      flash[:error] = 'Purchase Order had a problem saving, check server.'
      render json: {error: "#{@purchase_order.errors.full_messages}"}
    end
  end

  private
  def purchase_order_params
    params.require(:purchase_order).permit(:po_number, :vendor, :company_id, :item, :payment, :created_at, :updated_at, :image)
  end

end
