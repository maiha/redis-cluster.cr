module Redis::Cluster::Commands
  # Strings
  proxy get, key
  proxy set, key, val

  # Hashes
  proxy hget, key, field
  proxy hset, key, field, val
  proxy hgetall, key
end
