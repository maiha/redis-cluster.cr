require "./spec_helper"

class InfoMockedClient < Redis::Cluster::Client
  property! mock_cluster_info : Redis::Cluster::ClusterInfo
  def load_info
    mock_cluster_info
  end
end

describe Redis::Cluster::Client do
  info = Redis::Cluster::ClusterInfo.parse <<-EOF
    b3b2965 127.0.0.1:7001 myself,master - 0 0 2 connected 0-9990
    12acff8 127.0.0.1:7002 master - 0 1466253316377 1 connected 10000-16383
    bb6050b 127.0.0.1:7003 slave b3b2965 0 1466253315354 2 connected
    EOF

  describe "#cluster_info=" do
    it "should update slots" do
      client = Redis::Cluster.new(":6379")

      client.cover_slot?(0).should eq(false)
      client.cluster_info = info
      client.cover_slot?(0).should eq(true)
    end
  end

  describe "#cluster_info" do
    it "should update slots" do
      boot = Redis::Cluster::Bootstrap.parse(":6379")
      client = InfoMockedClient.new(boot)
      client.mock_cluster_info = info

      client.cover_slot?(0).should eq(false)
      client.cluster_info
      client.cover_slot?(0).should eq(true)
    end
  end
end
