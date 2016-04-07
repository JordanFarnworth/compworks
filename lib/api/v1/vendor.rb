module Api::V1::Vendor
  include Api::V1::Json

  def vendor_json(vendor, includes = {})
    attributes = %w(id name)

    api_json(vendor, only: attributes)
  end


  def vendors_json(vendors, includes = {})
    vendors.map { |v| vendor_json(v, includes) }
  end
end
