class Ahoy::Store < Ahoy::Stores::ActiveRecordTokenStore
  Ahoy.track_visits_immediately = true if Rails.env.test?
end
