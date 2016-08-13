require "./spec_helper"

describe Redis::Cluster::Commands do
  ######################################################################
  ### Aggregations
  
  describe "#counts" do
    it "connect to redis" do
      redis.counts.size.should eq(1)
    end
  end

  describe "#info" do
    it "shows given info" do
      redis.info("v").size.should eq(1)
    end
  end
end
