module Redis::Commands
  def raw(req : Array(RedisValue))
    cmd = req.first
    case cmd.downcase
    when "set"
      string_or_nil_command(req)
    when "get"
      string_or_nil_command(req)
    when "rename"
      string_command(req)
    when "renamenx"
      integer_command(req)
    when "del"
      integer_command(req)
    when "mget"
      string_array_command(req)
    when "mget"
      string_array_command(req)
    when "mset"
      string_command(req)
    when "getset"
      string_or_nil_command(req)
    when "setex"
      string_command(req)
    when "psetex"
      string_command(req)
    when "setnx"
      integer_command(req)
    when "msetnx"
      integer_command(req)
    when "incr"
      integer_command(req)
    when "decr"
      integer_command(req)
    when "incrby"
      integer_command(req)
    when "incrbyfloat"
      string_command(req)
    when "decrby"
      integer_command(req)
    when "append"
      integer_command(req)
    when "strlen"
      integer_command(req)
    when "getrange"
      string_command(req)
    when "setrange"
      integer_command(req)
    when "bitcount"
      integer_command(req)
    when "bitop"
      integer_command(req)
    when "getbit"
      integer_command(req)
    when "setbit"
      integer_command(req)
    when "bitpos"
      integer_command(req)
    when "dump"
      string_command(req)
    when "scan"
      string_array_command(req)
    when "randomkey"
      string_command(req)
    when "exists"
      integer_command(req)
    when "keys"
      string_array_command(req)
    when "rpush"
      integer_command(req)
    when "lpush"
      integer_command(req)
    when "lpush"
      integer_command(req)
    when "lpushx"
      integer_command(req)
    when "rpushx"
      integer_command(req)
    when "lrem"
      integer_command(req)
    when "llen"
      integer_command(req)
    when "lindex"
      string_or_nil_command(req)
    when "lset"
      string_command(req)
    when "lpop"
      string_or_nil_command(req)
    when "rpop"
      string_or_nil_command(req)
    when "linsert"
      integer_command(req)
    when "lrange"
      string_array_command(req)
    when "ltrim"
      string_command(req)
    when "sadd"
      integer_command(req)
    when "sadd"
      integer_command(req)
    when "smembers"
      string_array_command(req)
    when "sismember"
      integer_command(req)
    when "srem"
      integer_command(req)
    when "srem"
      integer_command(req)
    when "scard"
      integer_command(req)
    when "sdiff"
      string_array_command(req)
    when "sdiffstore"
      integer_command(req)
    when "sinter"
      string_array_command(req)
    when "sinterstore"
      integer_command(req)
    when "smove"
      integer_command(req)
    when "spop"
      string_array_or_string_or_nil_command(req)
    when "srandmember"
      string_array_or_string_or_nil_command(req)
    when "sscan"
      string_array_command(req)
    when "sunion"
      string_array_command(req)
    when "sunionstore"
      integer_command(req)
    when "blpop"
      array_or_nil_command(req)
    when "brpop"
      array_or_nil_command(req)
    when "rpoplpush"
      string_or_nil_command(req)
    when "brpoplpush"
      string_or_nil_command(req)
    when "hset"
      integer_command(req)
    when "hget"
      string_or_nil_command(req)
    when "hgetall"
      string_array_command(req)
    when "hdel"
      integer_command(req)
    when "hexists"
      integer_command(req)
    when "hincrby"
      integer_command(req)
    when "hincrbyfloat"
      string_command(req)
    when "hkeys"
      string_array_command(req)
    when "hlen"
      integer_command(req)
    when "hmget"
      string_array_command(req)
    when "hmset"
      string_command(req)
    when "hscan"
      string_array_command(req)
    when "hsetnx"
      integer_command(req)
    when "hvals"
      string_array_command(req)
    when "zadd"
      integer_command(req)
    when "zadd"
      integer_command(req)
    when "zrange"
      string_array_command(req)
    when "zcard"
      integer_command(req)
    when "zscore"
      string_or_nil_command(req)
    when "zcount"
      integer_command(req)
    when "zlexcount"
      integer_command(req)
    when "zincrby"
      string_command(req)
    when "zrem"
      integer_command(req)
    when "zrank"
      integer_or_nil_command(req)
    when "zrevrank"
      integer_or_nil_command(req)
    when "zinterstore"
      integer_command(req)
    when "zunionstore"
      integer_command(req)
    when "zrangebylex"
      string_array_command(req)
    when "zrangebyscore"
      string_array_command(req)
    when "zrevrange"
      string_array_command(req)
    when "zrevrangebylex"
      string_array_command(req)
    when "zrevrangebyscore"
      string_array_command(req)
    when "zremrangebylex"
      integer_command(req)
    when "zremrangebyrank"
      integer_command(req)
    when "zremrangebyscore"
      integer_command(req)
    when "zscan"
      string_array_command(req)
    when "pfadd"
      integer_command(req)
    when "pfmerge"
      string_command(req)
    when "pfcount"
      integer_command(req)
    when "script_exists"
      integer_array_command(req)
    when "flushall"
      string_command(req)
    when "expire"
      integer_command(req)
    when "pexpire"
      integer_command(req)
    when "expireat"
      integer_command(req)
    when "pexpireat"
      integer_command(req)
    when "persist"
      integer_command(req)
    when "ttl"
      integer_command(req)
    when "pttl"
      integer_command(req)
    when "type"
      string_command(req)
    when "info"
      string_command(req)
    else
      raise "raw `#{cmd}` is not supported yet"
    end
  end
end
