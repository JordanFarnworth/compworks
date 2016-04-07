module Api::V1::Item
  include Api::V1::Json

  def item_json(item, includes = {})
    attributes = %w(id name)

    api_json(item, only: attributes)
  end


  def items_json(items, includes = {})
    items.map { |i| item_json(i, includes) }
  end
end
