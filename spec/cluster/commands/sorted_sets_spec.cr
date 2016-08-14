require "./spec_helper"

describe "Commands" do
  describe "Sorted sets" do
    it "#zadd" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one").should eq(1)
      redis.zadd("myzset", [1, "uno"]).should eq(1)
      redis.zadd("myzset", 2, "two", 3, "three").should eq(2)
    end

    it "#zrange" do
      redis.zrange("myzset", 0, -1, with_scores: true).should eq(["one", "1", "uno", "1", "two", "2", "three", "3"])
    end

    it "#zrangebylex" do
      redis.del("myzset")
      redis.zadd("myzset", 0, "a", 0, "b", 0, "c", 0, "d", 0, "e", 0, "f", 0, "g")
      redis.zrangebylex("myzset", "-", "[c").should eq(["a", "b", "c"])
      redis.zrangebylex("myzset", "-", "(c").should eq(["a", "b"])
      redis.zrangebylex("myzset", "[aaa", "(g").should eq(["b", "c", "d", "e", "f"])
      redis.zrangebylex("myzset", "[aaa", "(g", limit: [0, 4]).should eq(["b", "c", "d", "e"])
    end

    it "#zrangebyscore" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zrangebyscore("myzset", "-inf", "+inf").should eq(["one", "two", "three"])
      redis.zrangebyscore("myzset", "-inf", "+inf", limit: [0, 2]).should eq(["one", "two"])
    end

    it "#zrevrange" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zrevrange("myzset", 0, -1).should eq(["three", "two", "one"])
      redis.zrevrange("myzset", 2, 3).should eq(["one"])
      redis.zrevrange("myzset", -2, -1).should eq(["two", "one"])
    end

    it "#zrevrangebylex" do
      redis.del("myzset")
      redis.zadd("myzset", 0, "a", 0, "b", 0, "c", 0, "d", 0, "e", 0, "f", 0, "g")
      redis.zrevrangebylex("myzset", "[c", "-").should eq(["c", "b", "a"])
      redis.zrevrangebylex("myzset", "(c", "-").should eq(["b", "a"])
      redis.zrevrangebylex("myzset", "(g", "[aaa").should eq(["f", "e", "d", "c", "b"])
      redis.zrevrangebylex("myzset", "+", "-", limit: [1, 1]).should eq(["f"])
    end

    it "#zrevrangebyscore" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zrevrangebyscore("myzset", "+inf", "-inf").should eq(["three", "two", "one"])
      redis.zrevrangebyscore("myzset", "+inf", "-inf", limit: [0, 2]).should eq(["three", "two"])
    end

    it "#zscore" do
      redis.del("myzset")
      redis.zadd("myzset", 2, "two")
      redis.zscore("myzset", "two").should eq("2")
    end

    it "#zcard" do
      redis.del("myzset")
      redis.zadd("myzset", 2, "two", 3, "three")
      redis.zcard("myzset").should eq(2)
    end

    it "#zcount" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zcount("myzset", "-inf", "+inf").should eq(3)
      redis.zcount("myzset", "(1", "3").should eq(2)
    end

    it "#zlexcount" do
      redis.del("myzset")
      redis.zadd("myzset", 0, "a", 0, "b", 0, "c", 0, "d", 0, "e", 0, "f", 0, "g")
      redis.zlexcount("myzset", "-", "+").should eq(7)
      redis.zlexcount("myzset", "[b", "[f").should eq(5)
    end

    it "#zrank" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zrank("myzset", "one").should eq(0)
      redis.zrank("myzset", "three").should eq(2)
      redis.zrank("myzset", "four").should eq(nil)
    end

    describe "#zscan" do
      it "no options" do
        redis.del("myset")
        redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
        new_cursor, keys = redis.zscan("myzset", 0)
        new_cursor.should eq("0")
        keys.should eq(["one", "1", "two", "2", "three", "3"])
      end

      it "with match" do
        redis.del("myzset")
        redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
        new_cursor, keys = redis.zscan("myzset", 0, "t*")
        new_cursor.should eq("0")
        keys.is_a?(Array).should be_true
        # extract odd elements for keys because zscan returns (key, val) as a single list
        keys = array(keys).in_groups_of(2).map(&.first.not_nil!)
        keys.should eq(["two", "three"])
      end

      pending "zscan doesn't handle COUNT strictly" do
        it "#zscan with match and count" do
        end
      end

      it "with match and count at once" do
        redis.del("myzset")
        redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
        new_cursor, keys = redis.zscan("myzset", 0, "t*", 1024)
        new_cursor.should eq("0")
        keys.is_a?(Array).should be_true
        # extract odd elements for keys because zscan returns (key, val) as a single list
        keys = array(keys).in_groups_of(2).map(&.first.not_nil!)
        keys.should eq(["two", "three"])
      end
    end

    it "#zrevrank" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zrevrank("myzset", "one").should eq(2)
      redis.zrevrank("myzset", "three").should eq(0)
      redis.zrevrank("myzset", "four").should eq(nil)
    end

    it "#zincrby" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one")
      redis.zincrby("myzset", 2, "one").should eq("3")
      redis.zrange("myzset", 0, -1, with_scores: true).should eq(["one", "3"])
    end

    it "#zrem" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zrem("myzset", "two").should eq(1)
      redis.zcard("myzset").should eq(2)
    end

    it "#zremrangebylex" do
      redis.del("myzset")
      redis.zadd("myzset", 0, "aaaa", 0, "b", 0, "c", 0, "d", 0, "e")
      redis.zadd("myzset", 0, "foo", 0, "zap", 0, "zip", 0, "ALPHA", 0, "alpha")
      redis.zremrangebylex("myzset", "[alpha", "[omega")
      redis.zrange("myzset", 0, -1).should eq(["ALPHA", "aaaa", "zap", "zip"])
    end

    it "#zremrangebyrank" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zremrangebyrank("myzset", 0, 1).should eq(2)
      redis.zrange("myzset", 0, -1, with_scores: true).should eq(["three", "3"])
    end

    it "#zremrangebyscore" do
      redis.del("myzset")
      redis.zadd("myzset", 1, "one", 2, "two", 3, "three")
      redis.zremrangebyscore("myzset", "-inf", "(2").should eq(1)
      redis.zrange("myzset", 0, -1, with_scores: true).should eq(["two", "2", "three", "3"])
    end

    it "#zinterstore" do
      redis.del("zset1", "zset2", "zset3")
      redis.zadd("zset1", 1, "one", 2, "two")
      redis.zadd("zset2", 1, "one", 2, "two", 3, "three")
      redis.zinterstore("zset3", ["zset1", "zset2"], weights: [2, 3]).should eq(2)
      redis.zrange("zset3", 0, -1, with_scores: true).should eq(["one", "5", "two", "10"])
    end

    it "#zunionstore" do
      redis.del("zset1", "zset2", "zset3")
      redis.zadd("zset1", 1, "one", 2, "two")
      redis.zadd("zset2", 1, "one", 2, "two", 3, "three")
      redis.zunionstore("zset3", ["zset1", "zset2"], weights: [2, 3]).should eq(3)
      redis.zrange("zset3", 0, -1, with_scores: true).should eq(["one", "5", "three", "9", "two", "10"])
    end
  end
end
