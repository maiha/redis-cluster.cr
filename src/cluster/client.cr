require "./commands"
require "./pool"

class Redis::Cluster::Client
  include Redis::Commands
  include Redis::Cluster::Commands
  include Redis::Cluster::Pool

  delegate nodes, to: cluster_info

  property bootstraps : Array(Bootstrap)
  
  def initialize(@bootstraps : Array(Bootstrap))
    @slot2addr  = Hash(Int32, Addr).new
    @addr2redis = Hash(Addr, Redis).new
  end

  # [syntax sugar]
  def initialize(bootstrap : Bootstrap)
    initialize([bootstrap])
  end

  def cluster_info
    if @cluster_info.nil?
      self.cluster_info = load_info
    end
      
    @cluster_info.not_nil!
  end

  def cluster_info=(info : ClusterInfo)
    @cluster_info = info
    @slot2addr = info.slot2addr.as(Hash(Int32, Addr))
  end

  def password
    if @bootstraps.empty?
      return nil
    else
      return @bootstraps.first.pass
    end
  end

  def ssl
    if @bootstraps.empty?
      return false
    else
      return @bootstraps.first.ssl
    end
  end

  def reset!
    conns = @addr2redis.values

    @cluster_info = nil
    @slot2addr.clear
    @addr2redis.clear

    conns.each do |redis|
      redis.close rescue nil
    end

    ready! # to call load_info
  end

  private def ready!
    cluster_info                # to initialize slots
  end

  private def load_info
    Redis::Cluster.load_info(@bootstraps)
  end
end
