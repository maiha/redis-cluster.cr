require "redis"

class Redis
  module Commands
    # EACH is a block-friendly alternative to SCAN
    #
    # **Options**:
    # see SCAN
    #
    # **Return value**: Nil
    #
    # Example:
    #
    # ```
    # redis.each { |key| p key }
    # redis.each(match: "foo:*") { |key| p key }
    # redis.each(count: 1000) { |key| p key }
    # ```
    
    def each(match = "*", count = 1000)
      each_keys(match: match, count: count) do |keys|
        keys.each do |key|
          yield key
        end
      end
    end

    # EACH_KEYS is same as EACH except this processes multiple keys at once.
    #
    # **Options**:
    # see SCAN
    #
    # **Return value**: Nil
    #
    # Example:
    #
    # ```
    # redis.each_keys { |keys| p keys }
    # redis.each_keys(match: "foo:*") { |keys| p keys }
    # redis.each_keys(count: 1000) { |keys| p keys }
    # ```

    def each_keys(match = "*", count = 1000)
      idx = 0
      while true
        idx, keys = scan(idx, match, count)
        unless idx.is_a?(String)
          raise "scan failed due to invalid idx: expected String but got `#{idx.class}'"
        end
        idx = idx.to_i
        unless keys.is_a?(Array)
          raise "scan failed due to invalid keys: expected Array but got `#{keys.class}'"
        end
        yield keys.map(&.to_s)  # `Redis::RedisValue` to `String`
        break if idx == 0
      end        
    end
  end
end
