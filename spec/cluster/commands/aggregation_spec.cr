require "./spec_helper"

describe Redis::Cluster::Commands do
  info = load_cluster_info("nodes/m1-6379.nodes")

  ######################################################################
  ### Aggregations
  
  describe "#counts" do
    it "connect to redis" do
      cluster = Redis::Cluster.new(info)
      cluster.counts.size.should eq(1)
      cluster.close
    end
  end

  describe "#info" do
    it "shows given info" do
      cluster = Redis::Cluster.new(info)
      cluster.info("v").size.should eq(1)
      cluster.close
    end
  end
end
