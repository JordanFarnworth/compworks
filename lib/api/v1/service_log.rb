module Api::V1::ServiceLog
  include Api::V1::Json

  def service_log_json(service_log, includes = {})
    attributes = %w(id company_id date length notes state payment)

    api_json(service_log, only: attributes).tap do |hash|
      hash['company'] = service_log.company.name
    end
  end


  def service_logs_json(service_logs, includes = {})
    service_logs.map { |sl| service_log_json(sl, includes) }
  end
end
