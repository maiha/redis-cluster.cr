[![Build Status](https://travis-ci.org/maiha/redis-cluster.cr.svg?branch=master)](https://travis-ci.org/maiha/redis-cluster.cr)

redis-cluster library for Crystal

- tested on crystal-0.19.3


## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  redis-cluster:
    github: maiha/redis-cluster.cr
```


## Usage

- assumes that our cluster is runing on localhost:7001 and 7002, ...

```crystal
require "redis-cluster"

bootstrap = "127.0.0.1:7001,127.0.0.1:7002"
cluster = Redis::Cluster.new(bootstrap)
# cluster = Redis::Cluster.new(bootstrap, password)

cluster.set "foo", "123"
cluster.get "foo"         # => "123"
cluster.counts.values     # => [0, 0, 1]

cluster.close
```

#### methods

See [crystal-redis](https://github.com/stefanwille/crystal-redis) because most of all methods are thin proxy to it.


## Supported API

See [API](https://github.com/maiha/redis-cluster.cr/blob/master/API.md)

## Redis::Client

#### Feature

- automatically creates standard client or clusterd client
- automatically reconnect to redis after connection errors

```crystal
redis = Redis::Client.new(host: "127.0.0.1", port: 6379, password: nil)
```

## TODO

#### v0.7.0

- [ ] Commands : Transactions

#### v0.6.0

- [x] Redis::Client for hybrid connection
- [x] Reconnect Automatically

## Contributing

1. Fork it ( https://github.com/maiha/redis-cluster.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
