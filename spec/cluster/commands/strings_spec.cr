require "./spec_helper"

describe "Commands" do
  describe "Strings" do
    it "#set" do
      redis.set("foo", "test")
    end

    it "#get" do
      redis.get("foo").should eq("test")
    end

    it "#set options" do
      redis.set("foo", "test", ex: 7)
      redis.ttl("foo").should eq(7)
    end

    it "#mget" do
      redis.set("foo1", "test1")
      redis.set("foo2", "test2")
      redis.mget("foo1", "foo2").should eq(["test1", "test2"])
      redis.mget(["foo2", "foo1"]).should eq(["test2", "test1"])
    end

    it "#mset" do
      redis.mset({"foo1" => "bar1", "foo2" => "bar2"})
      redis.get("foo1").should eq("bar1")
      redis.get("foo2").should eq("bar2")
    end

    it "#getset" do
      redis.set("foo", "old")
      redis.getset("foo", "new").should eq("old")
      redis.get("foo").should eq("new")
    end

    it "#setex" do
      redis.setex("foo", 3, "setexed")
      redis.get("foo").should eq("setexed")
    end

    it "#psetex" do
      redis.psetex("foo", 3000, "psetexed")
      redis.get("foo").should eq("psetexed")
    end

    it "#setnx" do
      redis.del("foo")
      redis.setnx("foo", "setnxed").should eq(1)
      redis.get("foo").should eq("setnxed")
      redis.setnx("foo", "setnxed2").should eq(0)
      redis.get("foo").should eq("setnxed")
    end

    it "#msetnx" do
      redis.del("key1", "key2", "key3")
      redis.msetnx({"key1": "hello", "key2": "there"}).should eq(1)
      redis.get("key1").should eq("hello")
      redis.get("key2").should eq("there")
      redis.msetnx({"key2": "keep", "key3": "singing"}).should eq(0)
      redis.get("key1").should eq("hello")
      redis.get("key2").should eq("there")
      redis.get("key3").should eq(nil)
    end

    it "#incr" do
      redis.set("foo", "3")
      redis.incr("foo").should eq(4)
    end

    it "#decr" do
      redis.set("foo", "3")
      redis.decr("foo").should eq(2)
    end

    it "#incrby" do
      redis.set("foo", "10")
      redis.incrby("foo", 4).should eq(14)
    end

    it "#decrby" do
      redis.set("foo", "10")
      redis.decrby("foo", 4).should eq(6)
    end

    it "#incrbyfloat" do
      redis.set("foo", "10")
      redis.incrbyfloat("foo", 2.5).should eq("12.5")
    end

    it "#append" do
      redis.set("foo", "hello")
      redis.append("foo", " world")
      redis.get("foo").should eq("hello world")
    end

    it "#strlen" do
      redis.set("foo", "Hello world")
      redis.strlen("foo").should eq(11)
      redis.del("foo")
      redis.strlen("foo").should eq(0)
    end

    it "#getrange" do
      redis.set("foo", "This is a string")
      redis.getrange("foo", 0, 3).should eq("This")
      redis.getrange("foo", -3, -1).should eq("ing")
    end

    it "#setrange" do
      redis.set("foo", "Hello world")
      redis.setrange("foo", 6, "Redis").should eq(11)
      redis.get("foo").should eq("Hello Redis")
    end
  end

  describe "bit operations" do
    it "#bitcount" do
      redis.set("foo", "foobar")
      redis.bitcount("foo", 0, 0).should eq(4)
      redis.bitcount("foo", 1, 1).should eq(6)
    end

    it "#bitop" do
      redis.set("key1", "foobar")
      redis.set("key2", "abcdef")
      redis.bitop("and", "dest", "key1", "key2").should eq(6)
      redis.get("dest").should eq("`bc`ab")
    end

    it "#bitpos" do
      redis.set("mykey", "0")
      redis.bitpos("mykey", 1).should eq(2)
    end

    it "#setbit" do
      redis.del("mykey")
      redis.setbit("mykey", 7, 1).should eq(0)
    end

    it "#getbit" do
      redis.getbit("mykey", 0).should eq(0)
      redis.getbit("mykey", 7).should eq(1)
      redis.getbit("mykey", 100).should eq(0)
    end
  end
end
