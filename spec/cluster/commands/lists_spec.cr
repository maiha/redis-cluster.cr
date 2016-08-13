require "./spec_helper"

describe "Commands" do
  describe "Lists" do
    it "#rpush" do
      redis.del("mylist")
      redis.rpush("mylist", "hello").should eq(1)
      redis.rpush("mylist", "world").should eq(2)
    end

    it "#lrange" do
      redis.lrange("mylist", 0, 1).should eq(["hello", "world"])
      redis.rpush("mylist", "snip", "snip").should eq(4)
    end

    it "#lpush" do
      redis.del("mylist")
      redis.lpush("mylist", "hello").should eq(1)
      redis.lpush("mylist", ["world"]).should eq(2)
      redis.lrange("mylist", 0, 1).should eq(["world", "hello"])
      redis.lpush("mylist", "snip", "snip").should eq(4)
    end

    it "#lpushx" do
      redis.del("mylist")
      redis.lpushx("mylist", "hello").should eq(0)
      redis.lrange("mylist", 0, 1).should eq([] of Redis::RedisValue)
      redis.lpush("mylist", "hello")
      redis.lpushx("mylist", "world").should eq(2)
      redis.lrange("mylist", 0, 1).should eq(["world", "hello"])
    end

    it "#lpushx" do
      redis.del("mylist")
      redis.rpushx("mylist", "hello").should eq(0)
      redis.lrange("mylist", 0, 1).should eq([] of Redis::RedisValue)
      redis.rpush("mylist", "hello")
      redis.rpushx("mylist", "world").should eq(2)
      redis.lrange("mylist", 0, 1).should eq(["hello", "world"])
    end

    it "#lrem" do
      redis.del("mylist")
      redis.rpush("mylist", "hello")
      redis.rpush("mylist", "my")
      redis.rpush("mylist", "world")
      redis.lrem("mylist", 1, "my").should eq(1)
      redis.lrange("mylist", 0, 1).should eq(["hello", "world"])
      redis.lrem("mylist", 0, "world").should eq(1)
      redis.lrange("mylist", 0, 1).should eq(["hello"])
    end

    it "#llen" do
      redis.del("mylist")
      redis.lpush("mylist", "hello")
      redis.lpush("mylist", "world")
      redis.llen("mylist").should eq(2)
    end

    it "#lset" do
      redis.del("mylist")
      redis.rpush("mylist", "hello")
      redis.rpush("mylist", "world")
      redis.lset("mylist", 0, "goodbye").should eq("OK")
      redis.lrange("mylist", 0, 1).should eq(["goodbye", "world"])
    end

    it "#lindex" do
      redis.del("mylist")
      redis.rpush("mylist", "hello")
      redis.rpush("mylist", "world")
      redis.lindex("mylist", 0).should eq("hello")
      redis.lindex("mylist", 1).should eq("world")
      redis.lindex("mylist", 2).should eq(nil)
    end

    it "#lpop" do
      redis.del("mylist")
      redis.rpush("mylist", "hello")
      redis.rpush("mylist", "world")
      redis.lpop("mylist").should eq("hello")
      redis.lpop("mylist").should eq("world")
      redis.lpop("mylist").should eq(nil)
    end

    it "#rpop" do
      redis.del("mylist")
      redis.rpush("mylist", "hello")
      redis.rpush("mylist", "world")
      redis.rpop("mylist").should eq("world")
      redis.rpop("mylist").should eq("hello")
      redis.rpop("mylist").should eq(nil)
    end

    it "#linsert" do
      redis.del("mylist")
      redis.rpush("mylist", "hello")
      redis.rpush("mylist", "world")
      redis.linsert("mylist", :before, "world", "dear").should eq(3)
      redis.lrange("mylist", 0, 2).should eq(["hello", "dear", "world"])
    end

    it "#ltrim" do
      redis.del("mylist")
      redis.rpush("mylist", "hello", "good", "world")
      redis.ltrim("mylist", 0, 0).should eq("OK")
      redis.lrange("mylist", 0, 2).should eq(["hello"])
    end

    it "#blpop" do
      redis.del("mylist")
      redis.del("myotherlist")
      redis.rpush("mylist", "hello", "world")
      redis.blpop(["myotherlist", "mylist"], 1).should eq(["mylist", "hello"])
    end

    it "#brpop" do
      redis.del("mylist")
      redis.del("myotherlist")
      redis.rpush("mylist", "hello", "world")
      redis.brpop(["myotherlist", "mylist"], 1).should eq(["mylist", "world"])
    end

    it "#rpoplpush" do
      redis.del("source")
      redis.del("destination")
      redis.rpush("source", "a", "b", "c")
      redis.rpush("destination", "1", "2", "3")
      redis.rpoplpush("source", "destination")
      redis.lrange("source", 0, 4).should eq(["a", "b"])
      redis.lrange("destination", 0, 4).should eq(["c", "1", "2", "3"])
    end

    it "#brpoplpush" do
      redis.del("source")
      redis.del("destination")
      redis.rpush("source", "a", "b", "c")
      redis.rpush("destination", "1", "2", "3")
      redis.brpoplpush("source", "destination", 0)
      redis.lrange("source", 0, 4).should eq(["a", "b"])
      redis.lrange("destination", 0, 4).should eq(["c", "1", "2", "3"])
    end
  end
end
