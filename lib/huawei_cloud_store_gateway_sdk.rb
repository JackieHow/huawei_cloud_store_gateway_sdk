# frozen_string_literal: true

require_relative "huawei_cloud_store_gateway_sdk/version"
require 'huawei_cloud_store_gateway_sdk/configuration'
require "uri"
require "digest"
require "openssl"
module HuaweiCloudStoreGatewaySdk
  module_function

  class << self
    attr_accessor :configuration
  end

  def configure
    self.configuration ||= HuaweiCloudStoreGatewaySdk::Configuration.new
    yield(configuration)
  end

  class Error < StandardError; end

  ALGORITHM = "SDK-HMAC-SHA256"
  HEADER_X_DATE = "X-Sdk-Date"
  HEADER_AUTHORIZATION = "Authorization"
  HOST = "Host"

  class HwStoreSDK
    attr_accessor :method, :uri, :headers, :body, :query, :app_key, :app_secret

    # rubocop: disable Metrics/ParameterLists
    def initialize(method, uri, headers, app_key, app_secret, body)
      @method = method
      @uri = URI(uri)
      @headers = headers.transform_keys(&:to_s)
      @body = body
      @query = @uri.query ? URI.decode_www_form(@uri.query).to_h : {}
      @app_key = app_key
      @app_secret = app_secret
    end

    def full_path
      path = @uri.path
      path = "#{path}?#{URI.encode_www_form(@query)}" unless @query.empty?
      "#{@uri.scheme}://#{@uri.host}#{path}"
    end
  end

  def sign_request(method, uri, headers, app_key, app_secret, body)
    request = HwStoreSDK.new(method, uri, headers, app_key, app_secret, body)
    sign_headers(request)
    {
      url: request.full_path,
      headers: request.headers,
      body: request.body
    }
  end

  # rubocop: enable Metrics/ParameterLists

  def sign_headers(request)
    canonical_request_str, current_time = request_to_string(request)
    string_to_sign = string_to_sign(canonical_request_str, current_time)
    signature = calculate_signature(request.app_secret, string_to_sign)
    request.headers[HEADER_AUTHORIZATION] = auth_header_value(request.app_key, signature, signed_headers(request))
  end

  def canonical_request(request)
    [
      request.method,
      canonical_uri(request),
      canonical_query_string(request),
      canonical_headers(request, signed_headers(request)),
      signed_headers(request).join(";"),
      payload_hash(request.body)
    ].join("\n")
  end

  def canonical_uri(request)
    request.uri.path.end_with?("/") ? request.uri.path : "#{request.uri.path}/"
  end

  def canonical_query_string(request)
    request.query.sort.map { |k, v| "#{url_encode(k)}=#{url_encode(v)}" }.join("&")
  end

  def canonical_headers(request, signed_headers)
    headers = {}
    request.headers.each do |key, value|
      headers[key.downcase] = value
    end

    headers_array = signed_headers.filter_map do |header|
      "#{header}:#{headers[header].strip}" if headers[header]
    end

    "#{headers_array.join("\n")}\n"
  end

  def signed_headers(request)
    request.headers.keys.map(&:downcase).sort
  end

  def payload_hash(body)
    Digest::SHA256.hexdigest(body)
  end

  def string_to_sign(canonical_request, current_time)
    [
      ALGORITHM,
      current_time,
      Digest::SHA256.hexdigest(canonical_request)
    ].join("\n")
  end

  def calculate_signature(app_secret, string_to_sign)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), app_secret, string_to_sign)
  end

  def auth_header_value(app_key, signature, signed_headers)
    "#{ALGORITHM} Access=#{app_key}, SignedHeaders=#{signed_headers.join(";")}, Signature=#{signature}"
  end

  def current_utc_time
    Time.now.utc.strftime("%Y%m%dT%H%M%SZ")
  end

  def url_encode(str)
    URI.encode_www_form_component(str)
  end

  def request_to_string(request)
    current_time = request.headers[HEADER_X_DATE].nil? ? current_utc_time : request.headers[HEADER_X_DATE]
    request.headers[HEADER_X_DATE] = current_time
    request.headers[HOST] = request.uri.host
    canonical_request_str = canonical_request(request)
    [canonical_request_str, current_time]
  end
end
