# frozen_string_literal: true

module Pardot
  class Client
    include HTTParty

    base_uri "https://pi.pardot.com"
    format :xml
    default_timeout 30

    include Authentication
    include Http

    include Objects::Accounts
    include Objects::Campaigns
    include Objects::CustomFields
    include Objects::Emails
    include Objects::Forms
    include Objects::Lists
    include Objects::ListMemberships
    include Objects::Opportunities
    include Objects::Prospects
    include Objects::ProspectAccounts
    include Objects::Users
    include Objects::Visitors
    include Objects::Visits
    include Objects::VisitorActivities

    attr_reader :email, :password, :user_key, :salesforce_access_token, :business_unit_id
    attr_accessor :api_key, :version, :format

    # @deprecated Arguments email, password and user_key are deprecated. Use salesforce_access_token with Salesforce OAuth.
    def initialize(email = nil, password = nil, user_key = nil, version = 3, salesforce_access_token = nil, business_unit_id = nil)
      warn "[DEPRECATION] Use of username and password authentication is deprecated in favor of Salesforce OAuth. See https://developer.pardot.com/kb/authentication/ for more information." unless email.nil? || password.nil? || user_key.nil?

      raise ConfigurationError, "business_unit_id required when using Salesforce access_token" if !salesforce_access_token.nil? && business_unit_id.nil?
      raise ConfigurationError, "Invalid business_unit_id value. Expected ID to start with '0Uv' and be length of 15 or 18 characters." if !business_unit_id.nil? && !(business_unit_id.start_with?("0Uv") && [15, 18].include?(business_unit_id.length))

      @email = email
      @password = password
      @user_key = user_key
      @version = version
      @salesforce_access_token = salesforce_access_token
      @business_unit_id = business_unit_id

      @format = "simple"
    end
  end
end
