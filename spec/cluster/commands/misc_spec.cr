require "./spec_helper"

describe "Commands" do
  describe "large values" do
    it "sends and receives a large value correctly" do
      redis.del("foo")
      large_value = "0123456789" * 100_000 # 1 MB
      redis.set("foo", large_value)
      redis.strlen("foo").should eq(1_000_000)
      redis.get("foo").not_nil!.size.should eq(1_000_000)
      redis.get("foo").should eq(large_value)
    end
  end
end
