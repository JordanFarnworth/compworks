class VendorsController < ApplicationController
    include Api::V1::Vendor

  def index
    @vendors = Vendor.all
    render json: @vendors, status: :ok
  end

  def vendor_search
    @vendors = Vendor.all
    if params[:search_term]
      t = params[:search_term]
      @vendors = @vendors.where('name ILIKE ?', "%#{t}%")
    end
    respond_to do |format|
      format.json do
        render json: vendors_json(@vendors), status: :ok
      end
      format.html do
      end
    end
  end
end
