module Redis::Cluster
  alias Counts = Hash(NodeInfo, Int64)
  alias Connection = ::Redis | ::Redis::Cluster::Client
end
