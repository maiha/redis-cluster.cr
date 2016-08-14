require "./spec_helper"

describe "Commands" do
  describe "keys" do
    it "#del" do
      redis.set("foo", "test")
      redis.del("foo")
      redis.get("foo").should eq(nil)
    end

    it "converts keys to strings" do
      redis.set(:foo, "hello")
      redis.set(123456, 7)
      redis.get("foo").should eq("hello")
      redis.get("123456").should eq("7")
    end

    it "#rename" do
      redis.del("foo", "bar")
      redis.set("foo", "test")
      redis.rename("foo", "bar")
      redis.get("bar").should eq("test")
    end

    it "#renamenx" do
      redis.set("foo", "Hello")
      redis.set("bar", "world")
      redis.renamenx("foo", "bar").should eq(0)
      redis.get("bar").should eq("world")
    end

    it "#randomkey" do
      redis.set("foo", "Hello")
      redis.randomkey.should_not be_nil
    end

    it "#exists" do
      redis.del("foo")
      redis.exists("foo").should eq(0)
      redis.set("foo", "test")
      redis.exists("foo").should eq(1)
    end

    it "#keys" do
      redis.set("callmemaybe", 1)
      redis.keys("callmemaybe").should eq(["callmemaybe"])
    end

    it "#type" do
      redis.set("foo", 3)
      redis.type("foo").should eq("string")
    end
  end
end
