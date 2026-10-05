# frozen_string_literal: true

module Pardot
  class Error < StandardError; end

  class NetError < Error; end

  class ExpiredApiKeyError < Error; end

  class AccessTokenExpiredError < Error; end

  class ConfigurationError < Error; end

  class ResponseError < Error
    def initialize(res = nil)
      @res = res
      super(to_s)
    end

    def to_s
      return @res["__content__"] if @res.is_a?(Hash)
      return @res.to_s unless @res.nil?

      super
    end

    def code
      @res.is_a?(Hash) ? @res["code"].to_i : 0
    end

    def inspect
      @res.inspect
    end
  end
end
