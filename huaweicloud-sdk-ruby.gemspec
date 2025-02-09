# frozen_string_literal: true

require_relative "lib/huawei_cloud_store_gateway_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "huaweicloud-sdk-ruby"
  spec.version = HuaweiCloudStoreGatewaySdk::VERSION
  spec.authors = ["jackie"]
  spec.email = ["hjq1033061893@gmail.com"]

  spec.summary = "Huawei Cloud Store Gateway SDK for Ruby."
  spec.description = "A Ruby SDK for interacting with Huawei Cloud Store Gateway, providing easy-to-use APIs."
  spec.homepage = "https://github.com/JackieHow/huaweicloud-sdk-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/JackieHow/huaweicloud-sdk-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/JackieHow/huaweicloud-sdk-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor]) || f.end_with?('.gem')
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
