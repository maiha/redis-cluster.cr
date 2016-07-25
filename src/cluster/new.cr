module Redis::Cluster
  def self.new(bootstrap : String, password : String? = nil) : Client
    Client.new(bootstrap, password)
  end

  # for internal or testing purpose
  def self.new(info : ClusterInfo, password : String? = nil) : Client
    bootstrap = info.nodes.map(&.addr).join(",")
    Client.new(bootstrap, password).tap(&.cluster_info = info)
  end
end
