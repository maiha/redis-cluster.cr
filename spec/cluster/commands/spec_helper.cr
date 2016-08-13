require "../spec_helper"

# Same as `sort` except sorting feature
protected def array(a) : Array(String)
  (a.as(Array(Redis::RedisValue))).map(&.to_s)
rescue
  raise "Cannot convert to Array(Redis::RedisValue): #{a.class}"
end
