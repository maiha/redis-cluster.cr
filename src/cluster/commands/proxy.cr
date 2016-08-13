module Redis::Cluster::Commands
  # Generic
  proxy del, key
  # [aggregation] proxy del, *keys
  
  # Strings
  proxy get, key
  proxy set, key, val

  # Sets
  proxy set, key, value, ex = nil, px = nil, nx = nil, xx = nil
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
  proxy srandmember, key
  proxy srandmember, key, count
  proxy sscan, key, cursor
  proxy sscan, key, cursor, match
  proxy sscan, key, cursor, match, count
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
  proxy hscan, key, cursor
  proxy hscan, key, cursor, match
  proxy hscan, key, cursor, match, count
  proxy hsetnx, key, field, value
  proxy hvals, key
end
