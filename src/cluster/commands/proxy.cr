module Redis::Cluster::Commands
  # Strings
  proxy get, key
  proxy set, key, val

  # Sets
  proxy sadd, key, *members
  proxy smembers, key

  # Hashes
  proxy hget, key, field
  proxy hset, key, field, val
  proxy hgetall, key
end
