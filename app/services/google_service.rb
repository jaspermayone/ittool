# API Endpoint docs that might be useful:
#
# - https://developers.google.com/admin-sdk/directory/reference/rest/v1/chromeosdevices/update
# - https://developers.google.com/admin-sdk/directory/v1/guides/manage-chrome-devices
# - https://developers.google.com/admin-sdk/directory/reference/rest/v1/customer.devices.chromeos/batchChangeStatus
#


class GoogleService
  include Singleton

  OOB_URI = "urn:ietf:wg:oauth:2.0:oob"
  SCOPE = [
    Google::Apis::AdminDirectoryV1::AUTH_ADMIN_DIRECTORY_DEVICE_CHROMEOS,
  ].freeze

  # this is a hack to work with the google library's requirement that tokens must be in files
  TOKEN_FILE = Tempfile.new("token")
  TOKEN_FILE << Rails.application.credentials.dig(:gsuite, :token)
  TOKEN_FILE.rewind
  TOKEN_FILE.close

  def authorize
    credentials = authorizer.get_credentials user_id
    if credentials.nil?
      url = authorizer.get_authorization_url base_url: OOB_URI
      puts "Open the following URL in the browser and enter the " \
           "resulting code after authorization:\n" + url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id:, code:, base_url: OOB_URI
      )
    end
    credentials
  end

  def client
    service = Google::Apis::AdminDirectoryV1::DirectoryService.new
    service.client_options.application_name = "IT Tool"
    service.client_options.log_http_requests = false
    service.authorization = authorize # calling the above method for authorization

    service
  end

  def list_chrome_devices
    client.list_chromeosdevices(customer: "my_customer")

    # This will return a list of ChromeOS devices
    # https://developers.google.com/admin-sdk/directory/v1/reference/chromeosdevices/list
  end

  def get_chrome_device(serialNumber)
    client.get_chromeosdevice(customer: "my_customer", serialNumber: serialNumber)

    # This will return a single ChromeOS device
    # https://developers.google.com/admin-sdk/directory/v1/reference/chromeosdevices/get
  end

  def update_chrome_device(serialNumber, device)
    client.update_chromeosdevice(customer: "my_customer", serialNumber: serialNumber, chrome_os_device_object: device)

    # This will update a ChromeOS device
    # https://developers.google.com/admin-sdk/directory/v1/reference/chromeosdevices/update
  end

  def disable_chrome_device(serialNumber)
    client.update_chromeosdevice(customer: "my_customer", serialNumber: serialNumber, chrome_os_device_object: {status: "DISABLED"})

    # This will disable a ChromeOS device
    # https://developers.google.com/admin-sdk/directory/v1/reference/chromeosdevices/update
  end

  def enable_chrome_device(serialNumber)
    client.update_chromeosdevice(customer: "my_customer", serialNumber: serialNumber, chrome_os_device_object: {status: "ACTIVE"})

    # This will enable a ChromeOS device
    # https://developers.google.com/admin-sdk/directory/v1/reference/chromeosdevices/update
  end

def toggle_chrome_device_status(serialNumber)
    device = get_chrome_device(serialNumber)
    if device.status == "ACTIVE"
      disable_chrome_device(serialNumber)
    else
      enable_chrome_device(serialNumber)
    end
end

def device_status(serialNumber)
    device = get_chrome_device(serialNumber)
    device.status
end

  private

  def client_id
    @client_id ||= Google::Auth::ClientId.from_hash JSON.parse(Rails.application.credentials.gsuite[:client_id_json])
  end

  def token_store
    @token_store ||= Google::Auth::Stores::FileTokenStore.new file: TOKEN_FILE.path
  end

  def authorizer
    @authorizer ||= Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  end

  def user_id
    "default"
  end

end
