module Api::V1::PurchaseOrder
  include Api::V1::Json
  include Api::V1::Item
  include Api::V1::Vendor
  include Api::V1::Company

  def purchase_order_json(purchase_order, includes = {})
    attributes = %w(id po_number payment)

    api_json(purchase_order, only: attributes).tap do |hash|
      hash['image'] = purchase_order.image.url(:medium)
      hash['company'] = company_json(purchase_order.company)
      hash['items'] = items_json(purchase_order.items)
      hash['vendor'] = vendors_json(purchase_order.vendors)
    end
  end


  def purchase_orders_json(purchase_orders, includes = {})
    purchase_orders.map { |p| purchase_order_json(p, includes) }
  end
end
