require "./spec_helper"

describe Redis::Cluster do
  describe ".new" do
    it "build instance from bootstrap" do
      cluster = Redis::Cluster.new(Bootstrap.new)
    end

    it "build instance from bootstrap string" do
      cluster = Redis::Cluster.new("127.0.0.1:6379")
      cluster.bootstraps.should eq([Bootstrap.parse("127.0.0.1:6379")])
    end

    it "build instance from bootstrap csv" do
      cluster = Redis::Cluster.new("127.0.0.1:6379,127.0.0.1:6380")
      cluster.bootstraps.size.should eq(2)
      cluster.bootstraps[0].should eq(Bootstrap.parse("127.0.0.1:6379"))
      cluster.bootstraps[1].should eq(Bootstrap.parse("127.0.0.1:6380"))
    end

    it "build instance from bootstrap csv with password" do
      cluster = Redis::Cluster.new("127.0.0.1:6379,127.0.0.1:6380", password: "secret")
      cluster.bootstraps.size.should eq(2)
      cluster.bootstraps[0].pass.should eq("secret")
      cluster.bootstraps[1].pass.should eq("secret")
    end

    it "we don't have cluster instances yet on travis" do
      cluster = Redis::Cluster.new("127.0.0.1:6379")
      # "ERR This instance has cluster support disabled"
      # "ERR unknown command 'CLUSTER'"
      expect_raises Redis::Error, /cluster/i do
        cluster.cluster_info
      end
    end
  end
end
