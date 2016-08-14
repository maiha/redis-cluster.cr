module Redis::Cluster::Commands
  # Keys
  proxy del, key, *keys
  proxy dump, key
  proxy exists, key
  proxy expire, key, seconds
  proxy expireat, key, timestamp
  # [aggregation] keys, pattern
  proxy pexpire, key, millis
  proxy pexpireat, key, unix_date_in_millis
  proxy persist, key
  proxy pttl, key
  proxy rename, key, new_key
  proxy renamenx, key, new_key
  # [custom] randomkey
  proxy ttl, key
  proxy type, key

  # Lists
  proxy rpush, key, *values
  proxy lpush, key, *values
  proxy lpush, key, values
  proxy lpushx, key, value
  proxy rpushx, key, value
  proxy lrem, key, count, value
  proxy llen, key
  proxy lindex, key, index
  proxy lset, key, index, value
  proxy lpop, key
  proxy rpop, key
  proxy linsert, key, where, pivot, value
  proxy lrange, key, from, to
  proxy ltrim, key, start, stop
  proxy_ary blpop, keys, timeout_in_seconds
  proxy_ary brpop, keys, timeout_in_seconds
  proxy rpoplpush, key, destination
  proxy brpoplpush, key, destination, timeout_in_seconds = nil
  
  # Strings
  proxy get, key
  proxy set, key, value, ex = nil, px = nil, nx = nil, xx = nil
  proxy mget, key, *keys
  proxy_hash mset, hash
  proxy getset, key, value
  proxy psetex, key, expire_in_milis, value
  proxy_hash msetnx, hash
  proxy incr, key
  proxy decr, key
  proxy incrby, key, increment
  proxy incrbyfloat, key, increment
  proxy decrby, key, decrement
  proxy append, key, value
  proxy strlen, key
  proxy getrange, key, start_index, end_index
  proxy setrange, key, start_index, value
  proxy bitcount, key, from = nil, to = nil
  proxy bitop, operation, key, *keys
  proxy getbit, key, index
  proxy setbit, key, index, value
  proxy bitpos, key, bit, start = nil, to = nil
  
  # Sets
  proxy setex, key, expire_in_seconds, value
  proxy setnx, key, value
  proxy strlen, key
  proxy setrange, key, start_index, value
  proxy setbit, key, index, value
  proxy scan, cursor, match = nil, count = nil
  proxy sadd, key, *values
  proxy smembers, key
  proxy sismember, key, value
  proxy srem, key, *values
  proxy scard, key
  proxy sdiff, key, *keys 
  proxy sdiffstore, key, *keys
  proxy sinter, key, *keys
  proxy sinterstore, key, *keys
  proxy smove, key, destination, member
  proxy spop, key
  proxy spop, key, count
  proxy srandmember, key, count = nil
  proxy sscan, key, cursor, match = nil, count = nil
  proxy sunion, key, *keys
  proxy sunionstore, key, *keys

  # Hashes
  proxy hset, key, field, value
  proxy hget, key, field
  proxy hgetall, key
  proxy hdel, key, field
  proxy hexists, key, field
  proxy hincrby, key, field, increment
  proxy hincrbyfloat, key, field, increment
  proxy hkeys, key
  proxy hlen, key
  proxy hmget, key, *fields
  proxy hmset, key, hash
  proxy hscan, key, cursor, match = nil, count = nil
  proxy hsetnx, key, field, value
  proxy hvals, key

  # Sorted Sets
  proxy zadd, key, *scores_and_members
  proxy zadd, key, scores_and_members : Array(RedisValue)
  proxy zrange, key, start, stop, with_scores = false
  proxy zcard, key
  proxy zscore, key, member
  proxy zcount, key, min, max
  proxy zlexcount, key, min, max
  proxy zincrby, key, increment, member
  proxy zrem, key, member
  proxy zrank, key, member
  proxy zrevrank, key, member
  proxy zinterstore, key, keys : Array, weights = nil, aggregate = nil
  proxy zunionstore, key, keys : Array, weights = nil, aggregate = nil
  proxy zrangebylex, key, min, max, limit = nil
  proxy zrangebyscore, key, min, max, limit = nil, with_scores = false
  proxy zrevrange, key, start, stop, with_scores = false
  proxy zrevrangebylex, key, min, max, limit = nil
  proxy zrevrangebyscore, key, min, max, limit = nil, with_scores = false
  proxy zremrangebylex, key, min, max
  proxy zremrangebyrank, key, start, stop
  proxy zremrangebyscore, key, start, stop
  proxy zscan, key, cursor, match = nil, count = nil
end
