[![CI](https://github.com/maiha/redis-cluster.cr/actions/workflows/ci.yml/badge.svg)](https://github.com/maiha/redis-cluster.cr/actions/workflows/ci.yml)

redis-cluster library for [Crystal](http://crystal-lang.org/).

- **supported versions** : 0.34.0, 1.21.1
- **crystal-redis** : using forked [maiha/crystal-redis](https://github.com/maiha/crystal-redis)
  - The original version [stefanwille/crystal-redis](https://github.com/stefanwille/crystal-redis) only supports the latest version of CRYSTAL.

## Classes

- Redis : a redis standard client (stefanwille/crystal-redis)
- Redis::Cluster : a redis cluster client (in this library)
- Redis::Client : a hybrid proxy to above clients (in this library)

## Supported API

See [API](https://github.com/maiha/redis-cluster.cr/blob/master/API.md)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  redis-cluster:
    github: maiha/redis-cluster.cr
```

## Usage

### Redis::Cluster client

- assumes that our cluster is runing on localhost:7001 and 7002, ...

```crystal
require "redis-cluster"

bootstrap = "127.0.0.1:7001,127.0.0.1:7002"
cluster = Redis::Cluster.new(bootstrap)
# cluster = Redis::Cluster.new(bootstrap, password: "secret")
# cluster = Redis::Cluster.new(bootstrap, password: "secret", ssl: true)

cluster.set "foo", "123"
cluster.get "foo"         # => "123"
cluster.counts.values     # => [0, 0, 1]

cluster.close
```

#### methods

See [crystal-redis](https://github.com/stefanwille/crystal-redis) because most of all methods are thin proxy to it.

### Redis client (enhancement)

This library also add some features to standard `Redis` libarary.

- [src/ext/redis/commands.cr](src/ext/redis/commands.cr)

### Redis::Client

This class is a high level hybrid client which can speak to both
standard and clustered redis nodes. And it also has a reconnecting feature.
Well, we don't care anything about the node is restarted or clustered or not.

So, the following code works on either redis mode.

```crystal
redis = Redis::Client.new(host: "127.0.0.1", port: 6379)
redis.get("foo")
```

### TLS/SSL Support

The library now supports secure connections via TLS/SSL for both standard Redis and cluster configurations:

#### Using rediss:// URLs

```crystal
# Single secure connection
cluster = Redis::Cluster.new("rediss://password@secure-redis.example.com:6380")

# Multiple secure nodes
cluster = Redis::Cluster.new("rediss://password@node1:6380,rediss://password@node2:6380")
```

#### Using SSL flags

```crystal
# Basic SSL connection
bootstrap = Redis::Cluster::Bootstrap.new(
  host: "secure-redis.example.com",
  port: 6380,
  pass: "password",
  ssl: true
)
cluster = Redis::Cluster::Client.new(bootstrap)

# With custom SSL context
ssl_context = OpenSSL::SSL::Context::Client.new
ssl_context.verify_mode = OpenSSL::SSL::VerifyMode::PEER
ssl_context.ca_certificates = "/path/to/ca-certificates.crt"

bootstrap = Redis::Cluster::Bootstrap.new(
  host: "secure-redis.example.com",
  port: 6380,
  pass: "password",
  ssl: true,
  ssl_context: ssl_context
)
cluster = Redis::Cluster::Client.new(bootstrap)
```

#### Hybrid client with TLS

```crystal
redis = Redis::Client.new(
  host: "secure-redis.example.com",
  port: 6380,
  password: "password",
  ssl: true
)
```

#### TLS with Unix sockets

```crystal
# Secure Unix socket connection
bootstrap = Redis::Cluster::Bootstrap.new(
  sock: "/tmp/redis-secure.sock",
  pass: "password",
  ssl: true
)
cluster = Redis::Cluster::Client.new(bootstrap)
```

### multi and pipelined

`Redis::Client#multi` and `pipelined` requires a key to resolve redis node.
In standard redis, the information is just ignored but it is necessary for hybrid api.

```crystal
redis.pipelined("foo") do |api|
  api.set("foo", 1)
  api.set("bar", 2) # raises unless both "foo" and "bar" are in the same node
end
```

When `reconnect` option is set, operations will be executed once again after connection error or hash slot error.

```crystal
redis.pipelined("foo", reconnect: true) do |api|
  ...
```

### Redis#each

Handy `SCAN` especially for block.

```crystal
redis = Redis.new
redis.each(count: 1000) |key|
redis.each_keys(count: 1000) |keys|
```

## RESTRICTION

- `multi` needs `key` for its first arg to resolve master node

```crystal
redis.multi("foo1") do |multi|
  multi.set("foo1", "first")
  multi.set("foo2", "second")
end
```

## Roadmap

#### v0.8.0

- [ ] define method explicitly
- [x] Commands : Pipeline

## Contributing

1. Fork it ( https://github.com/maiha/redis-cluster.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
- [Caspian Baska](https://github.com/caspiano) caspiano - contributor
