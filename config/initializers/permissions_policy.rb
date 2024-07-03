# Be sure to restart your server when you modify this file.

# Define an application-wide HTTP permissions policy. For further
# information see: https://developers.google.com/web/updates/2018/06/feature-policy

Rails.application.config.permissions_policy do |policy|
  # enable camera access for all origins
  policy.camera :self
  policy.gyroscope :none
  policy.microphone :none
  policy.usb :none
  policy.geolocation :none
  policy.midi :none
  policy.magnetometer :none
  policy.accelerometer :none
  policy.fullscreen :none
  # policy.payment :self, "https://secure.example.com"
end
