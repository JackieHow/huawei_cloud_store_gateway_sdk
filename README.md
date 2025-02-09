# HuaweiCloudStoreGatewaySdk

A Ruby SDK for interacting with Huawei Cloud's Store Gateway API. This SDK helps in generating request signatures and provides methods for configuring the SDK with your API key and secret to authenticate API requests.

## Installation

Add the following to your Gemfile:

```ruby
gem 'huawei_cloud_store_gateway_sdk'

Then run bundle install:

bundle install

Alternatively, you can install it directly via the terminal:

gem install huawei_cloud_store_gateway_sdk

Configuration

Before making requests with the SDK, you need to configure it with your app_key and app_secret. You can do this as follows:

HuaweiCloudStoreGatewaySdk.configure do |config|
  config.app_key = 'your_app_key'
  config.app_secret = 'your_app_secret'
end

Once the SDK is configured, you can access the configuration like this:

configuration = HuaweiCloudStoreGatewaySdk.configuration
puts configuration.app_key    # => 'your_app_key'
puts configuration.app_secret # => 'your_app_secret'

Usage

Signing Requests

The sign_request method signs the request with the provided HTTP method, URL, headers, app_key, and app_secret. It generates the required signature and includes it in the Authorization header.

Example usage:

url = "https://mkt.myhuaweicloud.com/api/mkp-openapi-public/global/v1/license/activate"
headers = {
  "x-stage" => "RELEASE",
  "X-Sdk-Date" => "20240317T144237Z",
  "Content-Type" => "application/json"
}
app_key = 'your_app_key'
app_secret = 'your_app_secret'
body = ''

result = HuaweiCloudStoreGatewaySdk.sign_request("POST", url, headers, body)
puts result[:headers]["Authorization"]

This will output the Authorization header with the correct signature.
  