module Api::V1::InventoryItem
  include Api::V1::Json

  def inventory_item_json(inventory_item, includes = {})
    attributes = %w(id company_id features created_at state)

    api_json(inventory_item, only: attributes)
  end

  def inventory_items_json(inventory_items, includes = {})
    inventory_items.map { |it| inventory_item_json(it, includes) }
  end
end
