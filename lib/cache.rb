# frozen_string_literal: true

require 'sinatra/base'
module Sinatra
  module FragmentCache
    # Caches the result of a block of code using Redis.
    #
    # @param cache_key [String] The key to use for caching the result.
    # @param ttl [Integer] The time-to-live for the cache entry, in seconds. Defaults to 24 hours (60 * 24 seconds).
    # @return [Object] The result of the block of code, or the cached result if it exists.
    # @yield The block of code to cache.
    def fragment_cache(cache_key, ttl = 60 * 24)
      return yield if ENV['RACK_ENV'] == 'test'
      return unless block_given?

      result = @redis.get(cache_key)
      if result
        logger.info '=' * 80
        logger.info "!!!! Cache HIT for 'text: #{params['text']}; to: #{params['to']}' !!!! "
        logger.info "!!!! key_key: #{cache_key} !!!!"
        logger.info '=' * 80
      else
        result = yield
        @redis.set(cache_key, result, ex: ttl) if result.code == 200
      end
      result
    end
  end
  helpers FragmentCache
end
