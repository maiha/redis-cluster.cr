module Redis::Cluster::Commands
  # Generic
  proxy del, key

  # Strings
  proxy get, key
  proxy set, key, val

  # Sets
  proxy sadd, key, *members
  proxy smembers, key

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
