require "./spec_helper"

describe "Commands" do
  describe "#raw" do
    it "sends redis protocol directly" do
      redis.raw(["DEL", "foo"])
      redis.raw(["SET", "foo", "test"])
      redis.get("foo").should eq("test")
      redis.raw(["GET", "foo"]).should eq("test")

      redis.raw(["DEL", "myset"])
      redis.raw(["SADD", "myset", "Hello"]).should eq(1)
      redis.raw(["SADD", "myset", "World"]).should eq(1)
      redis.raw(["SADD", "myset", "Hello"]).should eq(0)
      sort(redis.smembers("myset")).should eq(["Hello", "World"])
      sort(redis.raw(["SMEMBERS", "myset"])).should eq(["Hello", "World"])
    end
  end
end
