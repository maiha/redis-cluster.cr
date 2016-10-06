require "./commands"
require "./pool"

class Redis::Cluster::Client
  delegate nodes, to: cluster_info
  getter password

  property bootstraps : Array(Bootstrap)
  
  def initialize(@bootstraps : Array(Bootstrap), @password : String? = nil)
    @slot2addr  = Hash(Int32, Addr).new
    @addr2redis = Hash(Addr, Redis).new
  end

  # [syntax sugar]
  def initialize(bootstrap : Bootstrap, password : String? = nil)
    initialize([bootstrap], password: password)
  end

  def cluster_info
    if @cluster_info.nil?
      self.cluster_info = Redis::Cluster.load_info(@bootstraps, @password)
    end
    @cluster_info.not_nil!
  end

  def cluster_info=(info : ClusterInfo)
    @cluster_info = info
    @slot2addr = info.slot2addr.as(Hash(Int32, Addr))
  end

  private def ready!
    cluster_info                # to initialize slots
  end

  include Redis::Commands
  include Redis::Cluster::Commands
  include Redis::Cluster::Pool
end
