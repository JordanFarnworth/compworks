class ItemsController < ApplicationController
  include Api::V1::Item

  def item_search
    @items = Item.all
    if params[:search_term]
      t = params[:search_term]
      @items = @items.where('name ILIKE ?', "%#{t}%")
    end
    respond_to do |format|
      format.json do
        render json: items_json(@items), status: :ok
      end
      format.html do
      end
    end
  end
end
