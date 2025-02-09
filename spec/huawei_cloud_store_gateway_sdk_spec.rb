RSpec.describe HuaweiCloudStoreGatewaySdk do
  let(:url) { "https://mkt.myhuaweicloud.com/api/mkp-openapi-public/global/v1/license/activate" }
  let(:signature) { "Signature=77595ad624b6e4e49990b8c4e84bf1c287457fca61069c4e60b9b6765b52053d" }
  let(:headers) do
    {
      "x-stage" => "RELEASE",
      "X-Sdk-Date" => "20240317T144237Z",
      "Content-Type" => "application/json"
    }
  end
  let(:app_key) { 'test' }
  let(:app_secret) { '123' }

  describe 'sign_request' do

    it 'includes the correct signature in Authorization header' do
      result = described_class.sign_request("POST", url, headers, app_key, app_secret, "")
      expect(result[:headers]["Authorization"]).to include(signature)
    end

    it 'different app_key have same signature ' do
      result = described_class.sign_request("POST", url, headers, "wrong_key123", app_secret, "")
      expect(result[:headers]["Authorization"]).to include(signature)
    end

    it 'different secret, signature is different' do
      result = described_class.sign_request("POST", url, headers, app_key, 'wrong secret', "")
      expect(result[:headers]["Authorization"]).not_to include(signature)
    end
  end

  describe 'Check that the configuration is initialized correctly' do
    before do
      described_class.configure do |config|
        config.app_key = app_key
        config.app_secret = app_secret
      end
    end

    it 'correctly sets the configuration' do
      configuration = described_class.configuration
      expect(configuration.app_key).to eq(app_key)
      expect(configuration.app_secret).to eq(app_secret)
    end
  end

  describe 'init key and generate signature' do
    before do
      HuaweiCloudStoreGatewaySdk.configure do |config|
        config.app_key = nil
        config.app_secret = nil
      end
    end

    it 'loads and applies initial configuration correctly' do
      HuaweiCloudStoreGatewaySdk.configure do |config|
        config.app_key = app_key
        config.app_secret = app_secret
      end

      expect(HuaweiCloudStoreGatewaySdk.configuration.app_key).to eq(app_key)
      expect(HuaweiCloudStoreGatewaySdk.configuration.app_secret).to eq(app_secret)

      result = described_class.sign_request(
        "POST",
        url,
        headers,
        HuaweiCloudStoreGatewaySdk.configuration.app_key,
        HuaweiCloudStoreGatewaySdk.configuration.app_secret, ""
      )
      expect(result[:headers]["Authorization"]).to include(signature)
    end

    it 'not set configuration' do
      expect(HuaweiCloudStoreGatewaySdk.configuration.app_key).to be_nil
      expect(HuaweiCloudStoreGatewaySdk.configuration.app_secret).to be_nil
    end

  end

end
