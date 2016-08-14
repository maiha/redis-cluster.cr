# redis-cluster.cr 
## Supported API
### Connection (0 / 5)

|Command |impl|test|note|
|--------|:--:|:--:|----|
|`auth`  |    |    |    |
|`echo`  |    |    |    |
|`ping`  |    |    |    |
|`quit`  |    |    |    |
|`select`|    |    |    |

### Generic (16 / 22)

|Command    |impl|test|note|
|-----------|:--:|:--:|----|
|`del`      |  ✓ |  ✓ |    |
|`dump`     |  ✓ |    |    |
|`exists`   |  ✓ |  ✓ |    |
|`expire`   |  ✓ |  ✓ |    |
|`expireat` |  ✓ |  ✓ |    |
|`keys`     |  ✓ |  ✓ |    |
|`migrate`  |    |    |    |
|`move`     |    |    |    |
|`object`   |    |    |    |
|`persist`  |  ✓ |  ✓ |    |
|`pexpire`  |  ✓ |  ✓ |    |
|`pexpireat`|  ✓ |  ✓ |    |
|`pttl`     |  ✓ |  ✓ |    |
|`randomkey`|  ✓ |  ✓ |    |
|`rename`   |  ✓ |  ✓ |    |
|`renamenx` |  ✓ |  ✓ |    |
|`restore`  |    |    |    |
|`scan`     |  ✓ |    |    |
|`sort`     |    |    |    |
|`ttl`      |  ✓ |  ✓ |    |
|`type`     |  ✓ |  ✓ |    |
|`wait`     |    |    |    |

### Geo (0 / 6)

|Command            |impl|test|note|
|-------------------|:--:|:--:|----|
|`geoadd`           |    |    |    |
|`geodist`          |    |    |    |
|`geohash`          |    |    |    |
|`geopos`           |    |    |    |
|`georadius`        |    |    |    |
|`georadiusbymember`|    |    |    |

### Hash (14 / 15)

|Command       |impl|test|note|
|--------------|:--:|:--:|----|
|`hdel`        |  ✓ |  ✓ |    |
|`hexists`     |  ✓ |  ✓ |    |
|`hget`        |  ✓ |  ✓ |    |
|`hgetall`     |  ✓ |  ✓ |    |
|`hincrby`     |  ✓ |  ✓ |    |
|`hincrbyfloat`|  ✓ |  ✓ |    |
|`hkeys`       |  ✓ |  ✓ |    |
|`hlen`        |  ✓ |  ✓ |    |
|`hmget`       |  ✓ |  ✓ |    |
|`hmset`       |  ✓ |  ✓ |    |
|`hscan`       |  ✓ |  ✓ |    |
|`hset`        |  ✓ |  ✓ |    |
|`hsetnx`      |  ✓ |  ✓ |    |
|`hstrlen`     |    |    |Available since 3.2.0.|
|`hvals`       |  ✓ |  ✓ |    |

### Hyperloglog (3 / 3)

|Command  |impl|test|note|
|---------|:--:|:--:|----|
|`pfadd`  |  ✓ |  ✓ |    |
|`pfcount`|  ✓ |  ✓ |    |
|`pfmerge`|  ✓ |  ✓ |    |

### List (17 / 17)

|Command     |impl|test|note|
|------------|:--:|:--:|----|
|`blpop`     |  ✓ |  ✓ |    |
|`brpop`     |  ✓ |  ✓ |    |
|`brpoplpush`|  ✓ |  ✓ |    |
|`lindex`    |  ✓ |  ✓ |    |
|`linsert`   |  ✓ |  ✓ |    |
|`llen`      |  ✓ |  ✓ |    |
|`lpop`      |  ✓ |  ✓ |    |
|`lpush`     |  ✓ |  ✓ |    |
|`lpushx`    |  ✓ |  ✓ |    |
|`lrange`    |  ✓ |  ✓ |    |
|`lrem`      |  ✓ |  ✓ |    |
|`lset`      |  ✓ |  ✓ |    |
|`ltrim`     |  ✓ |  ✓ |    |
|`rpop`      |  ✓ |  ✓ |    |
|`rpoplpush` |  ✓ |  ✓ |    |
|`rpush`     |  ✓ |  ✓ |    |
|`rpushx`    |  ✓ |  ✓ |    |

### Pubsub (0 / 6)

|Command       |impl|test|note|
|--------------|:--:|:--:|----|
|`psubscribe`  |    |    |    |
|`publish`     |    |    |    |
|`pubsub`      |    |    |    |
|`punsubscribe`|    |    |    |
|`subscribe`   |    |    |    |
|`unsubscribe` |    |    |    |

### Scripting (0 / 7)

|Command        |impl|test|note|
|---------------|:--:|:--:|----|
|`eval`         |    |    |    |
|`evalsha`      |    |    |    |
|`script debug` |    |    |    |
|`script exists`|    |    |    |
|`script flush` |    |    |    |
|`script kill`  |    |    |    |
|`script load`  |    |    |    |

### Server (2 / 31)

|Command           |impl|test|note|
|------------------|:--:|:--:|----|
|`bgrewriteaof`    |    |    |    |
|`bgsave`          |    |    |    |
|`client getname`  |    |    |    |
|`client kill`     |    |    |    |
|`client list`     |    |    |    |
|`client pause`    |    |    |    |
|`client reply`    |    |    |    |
|`client setname`  |    |    |    |
|`command`         |    |    |    |
|`command count`   |    |    |    |
|`command getkeys` |    |    |    |
|`command info`    |    |    |    |
|`config get`      |    |    |    |
|`config resetstat`|    |    |    |
|`config rewrite`  |    |    |    |
|`config set`      |    |    |    |
|`dbsize`          |    |    |    |
|`debug object`    |    |    |    |
|`debug segfault`  |    |    |    |
|`flushall`        |  ✓ |    |    |
|`flushdb`         |    |    |    |
|`info`            |  ✓ |  ✓ |    |
|`lastsave`        |    |    |    |
|`monitor`         |    |    |    |
|`role`            |    |    |    |
|`save`            |    |    |    |
|`shutdown`        |    |    |    |
|`slaveof`         |    |    |    |
|`slowlog`         |    |    |    |
|`sync`            |    |    |    |
|`time`            |    |    |    |

### Set (15 / 15)

|Command      |impl|test|note|
|-------------|:--:|:--:|----|
|`sadd`       |  ✓ |  ✓ |    |
|`scard`      |  ✓ |  ✓ |    |
|`sdiff`      |  ✓ |  ✓ |    |
|`sdiffstore` |  ✓ |  ✓ |    |
|`sinter`     |  ✓ |  ✓ |    |
|`sinterstore`|  ✓ |  ✓ |    |
|`sismember`  |  ✓ |  ✓ |    |
|`smembers`   |  ✓ |  ✓ |    |
|`smove`      |  ✓ |  ✓ |    |
|`spop`       |  ✓ |  ✓ |    |
|`srandmember`|  ✓ |  ✓ |    |
|`srem`       |  ✓ |  ✓ |    |
|`sscan`      |  ✓ |  ✓ |    |
|`sunion`     |  ✓ |  ✓ |    |
|`sunionstore`|  ✓ |  ✓ |    |

### Sorted Set (21 / 21)

|Command           |impl|test|note|
|------------------|:--:|:--:|----|
|`zadd`            |  ✓ |  ✓ |    |
|`zcard`           |  ✓ |  ✓ |    |
|`zcount`          |  ✓ |  ✓ |    |
|`zincrby`         |  ✓ |  ✓ |    |
|`zinterstore`     |  ✓ |  ✓ |    |
|`zlexcount`       |  ✓ |  ✓ |    |
|`zrange`          |  ✓ |  ✓ |    |
|`zrangebylex`     |  ✓ |  ✓ |    |
|`zrangebyscore`   |  ✓ |  ✓ |    |
|`zrank`           |  ✓ |  ✓ |    |
|`zrem`            |  ✓ |  ✓ |    |
|`zremrangebylex`  |  ✓ |  ✓ |    |
|`zremrangebyrank` |  ✓ |  ✓ |    |
|`zremrangebyscore`|  ✓ |  ✓ |    |
|`zrevrange`       |  ✓ |  ✓ |    |
|`zrevrangebylex`  |  ✓ |  ✓ |    |
|`zrevrangebyscore`|  ✓ |  ✓ |    |
|`zrevrank`        |  ✓ |  ✓ |    |
|`zscan`           |  ✓ |  ✓ |    |
|`zscore`          |  ✓ |  ✓ |    |
|`zunionstore`     |  ✓ |  ✓ |    |

### String (23 / 24)

|Command      |impl|test|note|
|-------------|:--:|:--:|----|
|`append`     |  ✓ |  ✓ |    |
|`bitcount`   |  ✓ |  ✓ |    |
|`bitfield`   |    |    |Available since 3.2.0.|
|`bitop`      |  ✓ |  ✓ |    |
|`bitpos`     |  ✓ |  ✓ |    |
|`decr`       |  ✓ |  ✓ |    |
|`decrby`     |  ✓ |  ✓ |    |
|`get`        |  ✓ |  ✓ |    |
|`getbit`     |  ✓ |  ✓ |    |
|`getrange`   |  ✓ |  ✓ |    |
|`getset`     |  ✓ |  ✓ |    |
|`incr`       |  ✓ |  ✓ |    |
|`incrby`     |  ✓ |  ✓ |    |
|`incrbyfloat`|  ✓ |  ✓ |    |
|`mget`       |  ✓ |  ✓ |    |
|`mset`       |  ✓ |  ✓ |    |
|`msetnx`     |  ✓ |  ✓ |    |
|`psetex`     |  ✓ |  ✓ |    |
|`set`        |  ✓ |  ✓ |    |
|`setbit`     |  ✓ |  ✓ |    |
|`setex`      |  ✓ |  ✓ |    |
|`setnx`      |  ✓ |  ✓ |    |
|`setrange`   |  ✓ |  ✓ |    |
|`strlen`     |  ✓ |  ✓ |    |

### Transactions (0 / 5)

|Command  |impl|test|note|
|---------|:--:|:--:|----|
|`discard`|    |    |    |
|`exec`   |    |    |    |
|`multi`  |    |    |    |
|`unwatch`|    |    |    |
|`watch`  |    |    |    |

