require "./spec_helper"

describe Redis::Cluster::Commands do
  info = load_cluster_info("nodes/m1-6379.nodes")

  ######################################################################
  ### Strings
  
  describe "#get" do
    it "connect to proper node" do
      cluster = Redis::Cluster.new(info)
      cluster.get("3194")
      cluster.close
    end
  end

  describe "#set" do
    it "connect to proper node" do
      cluster = Redis::Cluster.new(info)
      value = rand(10000).to_s
      cluster.set("3194", value)
      cluster.get("3194").should eq(value)
      cluster.close
    end
  end

  ######################################################################
  ### Sets
  
  describe "#sadd" do
    it "connect to proper node" do
      cluster = Redis::Cluster.new(info)
      cluster.sadd("myset", "Hello")
      cluster.sadd("myset", "World")
      cluster.sadd("myset", "World")
      cluster.close
    end
  end

  describe "#smembers" do
    it "connect to proper node" do
      cluster = Redis::Cluster.new(info)
      cluster.smembers("myset").map(&.to_s).sort.should eq(["Hello", "World"])
      cluster.close
    end
  end

  ######################################################################
  ### Hashes
  
  describe "#hset" do
    it "connect to proper node" do
      cluster = Redis::Cluster.new(info)
      cluster.hset("myhash1", "field1", "Hello")
      cluster.hset("myhash1", "field2", "World")
      cluster.close
    end
  end

  describe "#hget" do
    it "connect to proper node" do
      cluster = Redis::Cluster.new(info)
      cluster.hget("myhash1", "field1").should eq("Hello")
      cluster.hget("myhash1", "field2").should eq("World")
      cluster.close
    end
  end

  describe "#hgetall" do
    it "connect to proper node" do
      cluster = Redis::Cluster.new(info)
      cluster.hgetall("myhash1").should eq(["field1", "Hello", "field2", "World"])
      cluster.close
    end
  end

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
