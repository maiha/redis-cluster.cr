require "./spec_helper"

describe "Commands" do
  describe "hyperloglog" do
    it "#pfadd" do
      redis.del("hll")
      redis.pfadd("hll", "a", "b", "c", "d", "e", "f", "g").should eq(1)
    end

    it "#pfcount" do
      redis.pfcount("hll").should eq(7)
    end

    it "#pfmerge" do
      redis.del("hll1", "hll2", "hll3")
      redis.pfadd("hll1", "foo", "bar", "zap", "a")
      redis.pfadd("hll2", "a", "b", "c", "foo")
      redis.pfmerge("hll3", "hll1", "hll2").should eq("OK")
      redis.pfcount("hll3").should eq(6)
    end
  end
end
