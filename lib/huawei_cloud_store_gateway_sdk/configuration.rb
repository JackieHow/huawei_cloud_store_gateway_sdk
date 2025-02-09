# frozen_string_literal: true

module HuaweiCloudStoreGatewaySdk
  class Configuration
    attr_accessor :app_key, :app_secret

    def initialize
      @app_key = ''
      @app_secret = ''
    end
  end
end
