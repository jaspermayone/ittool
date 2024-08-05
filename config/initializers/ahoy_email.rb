class EmailSubscriber
  def track_send(data)
    # your code
  end

  def track_click(data)
    # your code
  end

  def stats(campaign)
    # optional, for AhoyEmail.stats
  end
end

AhoyEmail.default_options[:message] = true
AhoyEmail.subscribers << AhoyEmail::DatabaseSubscriber
AhoyEmail.api = true
