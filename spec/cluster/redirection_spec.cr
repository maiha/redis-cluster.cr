require "./spec_helper"

describe "redirection" do

  describe "MOVED" do
    it "should update slot mapping" do
      info = load_cluster_info("nodes/m1-6379.nodes")
      cluster = new_redis_cluster(info)
      cluster.addr("3194").should eq(Redis::Cluster::Addr.new("127.0.0.1", 6379))

      # emulate redirection
      cluster.on_moved(Redis::Error::Moved.new(3194, "127.0.0.2:7001"))
      cluster.addr("3194").should eq(Redis::Cluster::Addr.new("127.0.0.2", 7001))

      cluster.close
    end
  end

  describe "ASK" do
    it "should just proxy" do
      info = load_cluster_info("nodes/m1-6379.nodes")
      cluster = new_redis_cluster(info)
      cluster.addr("3194").should eq(Redis::Cluster::Addr.new("127.0.0.1", 6379))

      pending "too hard to emulate ASK without cluster" do
        # "ASK 3194 127.0.0.1:7001"
        cluster.on_ask(Redis::Error::Ask.new(3194, "127.0.0.2:7001"))
        cluster.addr("3194").should eq(Redis::Cluster::Addr.new("127.0.0.1", 6379))
      end

      cluster.close
    end
  end
end
