require "./commands"
require "./pool"

class Redis::Cluster::Client
  delegate nodes, to: cluster_info

  def initialize(bootstrap : String, @password : String? = nil)
    @slot2addr  = Hash(Int32, Addr).new
    @addr2redis = Hash(Addr, Redis).new
    if bootstrap.empty?
      @bootstraps = Array(Addr).new
    else
      @bootstraps = bootstrap.split(",").map{|b| Addr.parse(b.strip)}
    end
  end

  def cluster_info
    if @cluster_info.nil?
      self.cluster_info = Redis::Cluster.load_info(@bootstraps.not_nil!, @password)
    end
    @cluster_info.not_nil!
  end

  def cluster_info=(info : ClusterInfo)
    @cluster_info = info
    @slot2addr = info.slot2addr.as(Hash(Int32, Addr))
  end

  def bootstraps=(addrs : Array(Addr))
    @bootstraps = addrs
  end

  private def ready!
    cluster_info                # to initialize slots
  end

  include Redis::Commands
  include Redis::Cluster::Commands
  include Redis::Cluster::Pool
end
