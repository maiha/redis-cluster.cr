require "./spec_helper"

describe Redis::Cluster do
  describe ".new" do
    it "build instance from bootstrap" do
      cluster = Redis::Cluster.new(Bootstrap.new)
    end

    it "build instance from bootstrap string" do
      cluster = Redis::Cluster.new("127.0.0.1:6379")
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
