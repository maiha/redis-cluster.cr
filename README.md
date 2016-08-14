[![Build Status](https://travis-ci.org/maiha/redis-cluster.cr.svg?branch=master)](https://travis-ci.org/maiha/redis-cluster.cr)

redis-cluster library for Crystal

- tested on crystal-0.18.7


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


## Supported API

see [API](https://github.com/maiha/redis-cluster.cr/blob/master/API.md)


## TODO

#### v0.6.0

- [ ] Commands : Transactions

#### v0.5.0

- [ ] Commands : Sorted Sets
- [x] Commands : Strings
- [x] Commands : Lists


## Contributing

1. Fork it ( https://github.com/maiha/redis-cluster.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request


## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
