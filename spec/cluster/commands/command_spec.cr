require "./spec_helper"

describe "Commands" do
  describe "#command" do
    it "sends redis protocol directly" do
      redis.command(["DEL", "foo"])
      redis.command(["SET", "foo", "test"])
      redis.get("foo").should eq("test")
      redis.command(["GET", "foo"]).should eq("test")

      redis.command(["DEL", "myset"])
      redis.command(["SADD", "myset", "Hello"]).should eq(1)
      redis.command(["SADD", "myset", "World"]).should eq(1)
      redis.command(["SADD", "myset", "Hello"]).should eq(0)
      sort(redis.smembers("myset")).should eq(["Hello", "World"])
      sort(redis.command(["SMEMBERS", "myset"])).should eq(["Hello", "World"])
    end
  end
end
