class PurchaseOrdersController < ApplicationController
  include Api::V1::PurchaseOrder

  def index
    @paid_pos = PurchaseOrder.paid.order(created_at: :desc).includes(:company, :items).paginate(page: params[:page], per_page: 15)
    @unpaid_pos = PurchaseOrder.unpaid.order(created_at: :desc).includes(:company, :items).paginate(page: params[:page], per_page: 15)
  end

  def show
    @po = PurchaseOrder.find params[:id]
    respond_to do |format|
      format.json do
        render json: purchase_order_json(@po), status: :ok
      end
      format.html do
      end
    end
  end

  def new
    @po ||= PurchaseOrder.new
  end

  def destroy
    @purchase_order = PurchaseOrder.find params[:id]
    respond_to do |format|
      format.json do
        @purchase_order.purchase_order_vendors.destroy_all
        @purchase_order.item_joiners.destroy_all
        @purchase_order.delete
        render json: {success: "Purchase Order was Successfully deleted"}
      end
      format.html do
      end
    end
  end

  def make_po_received
    @po = PurchaseOrder.find params[:id]
    respond_to do |format|
      format.json do
        @po.payment = true
        @po.save
        render json: purchase_order_json(@po), status: :ok
      end
    end
  end

  def make_po_unreceived
    @po = PurchaseOrder.find params[:id]
    respond_to do |format|
      format.json do
        @po.payment = false
        @po.save
        render json: purchase_order_json(@po), status: :ok
      end
    end
  end

  def create
    po_params = purchase_order_params.tap {|at| at.delete("item")}
    po_params = po_params.tap {|at| at.delete("vendor")}
    if po_params["image"] == "undefined"
      po_params = po_params.tap {|at| at.delete("image")}
    end
    @purchase_order = PurchaseOrder.new po_params
    @item = Item.find_or_create_by(name: purchase_order_params["item"])
    @vendor = Vendor.find_or_create_by(name: purchase_order_params["vendor"])
    if @purchase_order.save
      @ij = ItemJoiner.find_or_create_by(item_id: @item.id, purchase_order_id: @purchase_order.id)
      unless @ij.persisted?
        @ij.save
      end
      @pov = PurchaseOrderVendor.find_or_create_by(vendor_id: @vendor.id, purchase_order_id: @purchase_order.id)
      unless @pov.persisted?
        @pov.save
      end
      render json: @purchase_order, status: :ok
    else
      flash[:error] = 'Purchase Order had a problem saving, check server.'
      render json: {error: "#{@purchase_order.errors.full_messages}"}
    end
  end

  def update
    @purchase_order = PurchaseOrder.find params[:id]
    @purchase_order.purchase_order_vendors.destroy_all
    @purchase_order.item_joiners.destroy_all
    po_params = purchase_order_params.tap {|at| at.delete("item")}
    po_params = po_params.tap {|at| at.delete("vendor")}
    @item = Item.find_or_create_by(name: purchase_order_params["item"])
    @vendor = Vendor.find_or_create_by(name: purchase_order_params["vendor"])
    if @purchase_order.update po_params
      @ij = ItemJoiner.find_or_create_by(item_id: @item.id, purchase_order_id: @purchase_order.id)
      unless @ij.persisted?
        @ij.save
      end
      @pov = PurchaseOrderVendor.find_or_create_by(vendor_id: @vendor.id, purchase_order_id: @purchase_order.id)
      unless @pov.persisted?
        @pov.save
      end
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
