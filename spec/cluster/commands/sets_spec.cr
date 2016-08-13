require "./spec_helper"

describe "Commands" do
  describe "Sets" do
    it "#sadd" do
      redis.del("myset")
      redis.sadd("myset", "Hello").should eq(1)
      redis.sadd("myset", "World").should eq(1)
      redis.sadd("myset", "World").should eq(0)
      redis.sadd("myset", ["Foo", "Bar"]).should eq(2)
    end

    it "#smembers" do
      sort(redis.smembers("myset")).should eq(["Bar", "Foo", "Hello", "World"])
    end

    it "#scard" do
      redis.del("myset")
      redis.sadd("myset", "Hello", "World")
      redis.scard("myset").should eq(2)
    end

    it "#sismember" do
      redis.del("key1")
      redis.sadd("key1", "a")
      redis.sismember("key1", "a").should eq(1)
      redis.sismember("key1", "b").should eq(0)
    end

    it "#srem" do
      redis.del("myset")
      redis.sadd("myset", "Hello", "World")
      redis.srem("myset", "Hello").should eq(1)
      redis.smembers("myset").should eq(["World"])

      redis.sadd("myset", ["Hello", "World", "Foo"])
      redis.srem("myset", ["Hello", "Foo"]).should eq(2)
      redis.smembers("myset").should eq(["World"])
    end

    it "#sdiff" do
      redis.del("key1", "key2")
      redis.sadd("key1", "a", "b", "c")
      redis.sadd("key2", "c", "d", "e")
      sort(redis.sdiff("key1", "key2")).should eq(["a", "b"])
    end

    it "#spop" do
      redis.del("myset")
      redis.sadd("myset", "one")
      redis.spop("myset").should eq("one")
      redis.smembers("myset").should eq([] of Redis::RedisValue)
      # Redis 3.0 should have received the "count" argument, but hasn't.
      #
      # redis.sadd("myset", "one", "two")
      # sort(redis.spop("myset", count: 2)).should eq(["one", "two"])

      redis.del("myset")
      redis.spop("myset").should eq(nil)
    end

    it "#sdiffstore" do
      redis.del("key1", "key2", "destination")
      redis.sadd("key1", "a", "b", "c")
      redis.sadd("key2", "c", "d", "e")
      redis.sdiffstore("destination", "key1", "key2").should eq(2)
      sort(redis.smembers("destination")).should eq(["a", "b"])
    end

    it "#sinter" do
      redis.del("key1", "key2")
      redis.sadd("key1", "a", "b", "c")
      redis.sadd("key2", "c", "d", "e")
      redis.sinter("key1", "key2").should eq(["c"])
    end

    it "#sinterstore" do
      redis.del("key1", "key2", "destination")
      redis.sadd("key1", "a", "b", "c")
      redis.sadd("key2", "c", "d", "e")
      redis.sinterstore("destination", "key1", "key2").should eq(1)
      redis.smembers("destination").should eq(["c"])
    end

    it "#sunion" do
      redis.del("key1", "key2")
      redis.sadd("key1", "a", "b")
      redis.sadd("key2", "c", "d")
      sort(redis.sunion("key1", "key2")).should eq(["a", "b", "c", "d"])
    end

    it "#sunionstore" do
      redis.del("key1", "key2", "destination")
      redis.sadd("key1", "a", "b")
      redis.sadd("key2", "c", "d")
      redis.sunionstore("destination", "key1", "key2").should eq(4)
      sort(redis.smembers("destination")).should eq(["a", "b", "c", "d"])
    end

    it "#smove" do
      redis.del("key1", "key2", "destination")
      redis.sadd("key1", "a", "b")
      redis.sadd("key2", "c")
      redis.smove("key1", "key2", "b").should eq(1)
      redis.smembers("key1").should eq(["a"])
      sort(redis.smembers("key2")).should eq(["b", "c"])
    end

    it "#srandmember" do
      redis.del("key1", "key2", "destination")
      redis.sadd("key1", "a")
      redis.srandmember("key1", 1).should eq(["a"])
    end

    describe "#sscan" do
      it "no options" do
        redis.del("myset")
        redis.sadd("myset", "a", "b")
        new_cursor, keys = redis.sscan("myset", 0)
        new_cursor.should eq("0")
        sort(keys).should eq(["a", "b"])
      end

      it "with match" do
        redis.del("myset")
        redis.sadd("myset", "foo", "bar", "foo2", "foo3")
        new_cursor, keys = redis.sscan("myset", 0, "foo*", 2)
        new_cursor = new_cursor.as(String)
        keys.is_a?(Array).should be_true
        array(keys).size.should be > 0
      end

      it "with match and count" do
        redis.del("myset")
        redis.sadd("myset", "foo", "bar", "baz")
        new_cursor, keys = redis.sscan("myset", 0, "*a*", 1)
        new_cursor = new_cursor.as(String)
        new_cursor.to_i.should be > 0
        keys.is_a?(Array).should be_true
        # TODO SW: This assertion fails randomly
        # array(keys).size.should be > 0
      end

      it "with match and count at once" do
        redis.del("myset")
        redis.sadd("myset", "foo", "bar", "baz")
        new_cursor, keys = redis.sscan("myset", 0, "*a*", 10)
        new_cursor.should eq("0")
        keys.is_a?(Array).should be_true
        array(keys).sort.should eq(["bar", "baz"])
      end
    end
  end
end
