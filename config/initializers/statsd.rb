Rails.application.configure do
  # StatsD config here
  ENV["STATSD_ENV"] = "production" # This won't send data unless set to production
  ENV["STATSD_ADDR"] = Rails.application.credentials.dig(:telem, :endpoint)
  ENV["STATSD_PREFIX"] = "#{Rails.env}.ittool"

  StatsD::Instrument::Environment.setup

  StatsD.increment("startup", 1)
end
