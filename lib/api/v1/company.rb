module Api::V1::Company
  include Api::V1::Json

  def company_json(company, includes = {})
    attributes = %w(id name network domain antivirus router1 router2 created_at state)

    api_json(company, only: attributes)
  end


  def companies_json(companies, includes = {})
    companies.map { |c| company_json(c, includes) }
  end
end
