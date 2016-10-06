require "spec"
require "../src/redis-cluster"

include Redis::Cluster

def fixtures(name)
  File.read("#{__DIR__}/fixtures/#{name}")
end

# derived from "src/redis/commands.cr"
def redis_info(bulk)
  results = Hash(String, String).new
  bulk.split("\n").each do |line|
    next if line.empty? || line[0] == '#'
    key, val = line.split(":")
    results[key] = val
  end
  results
end

def load_cluster_info(name)
  ClusterInfo.parse(fixtures(name))
end

def node_mark(node : NodeInfo)
  if node.serving?
    "M"
  elsif node.master?
    "-"
  else
    "S"
  end
end

def array2hash(args : Array(String))
  hash = Hash(String, String).new
  args.each_with_index do |v, i|
    hash[args[i-1].not_nil!] = v if i.odd?
  end
  return hash
end

module TestRedisPool
  CLIENTS = [] of Redis::Cluster::Client
end

protected def new_redis_cluster(info : Redis::Cluster::ClusterInfo)
  bootstraps = info.nodes.map{|n| Redis::Cluster::Bootstrap.new(n.addr.to_s)}
  Redis::Cluster::Client.new(bootstraps).tap(&.cluster_info = info)
end

protected def redis_cluster_client
  TestRedisPool::CLIENTS.first {
    info = load_cluster_info("nodes/m1-6379.nodes")
    r = new_redis_cluster(info)
    r.flushall
    TestRedisPool::CLIENTS << r
    r
  }
end
