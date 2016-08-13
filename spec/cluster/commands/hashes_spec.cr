require "./spec_helper"

# derived from "crystal-redis.cr"

describe "Commands" do
  info = load_cluster_info("nodes/m1-6379.nodes")
  redis = Redis::Cluster.new(info)
  redis.flushall

  describe "Hashes" do
    it "#hset / #hget" do
      redis.del("myhash")
      redis.hset("myhash", "a", "434")
      redis.hget("myhash", "a").should eq("434")
    end

    it "#hgetall" do
      redis.del("myhash")
      redis.hset("myhash", "a", "123")
      redis.hset("myhash", "b", "456")
      redis.hgetall("myhash").should eq(["a", "123", "b", "456"])
    end

    it "#hdel" do
      redis.del("myhash")
      redis.hset("myhash", "field1", "foo")
      redis.hdel("myhash", "field1").should eq(1)
      redis.hget("myhash", "field1").should eq(nil)
    end

    it "#hexists" do
      redis.del("myhash")
      redis.hset("myhash", "field1", "foo")
      redis.hexists("myhash", "field1").should eq(1)
      redis.hexists("myhash", "field2").should eq(0)
    end

    it "#hincrby" do
      redis.del("myhash")
      redis.hset("myhash", "field1", "1")
      redis.hincrby("myhash", "field1", "3").should eq(4)
    end

    it "#hincrbyfloat" do
      redis.del("myhash")
      redis.hset("myhash", "field1", "10.50")
      redis.hincrbyfloat("myhash", "field1", "0.1").should eq("10.6")
    end

    it "#hkeys" do
      redis.del("myhash")
      redis.hset("myhash", "field1", "1")
      redis.hset("myhash", "field2", "2")
      redis.hkeys("myhash").should eq(["field1", "field2"])
    end

    it "#hlen" do
      redis.del("myhash")
      redis.hset("myhash", "field1", "1")
      redis.hset("myhash", "field2", "2")
      redis.hlen("myhash").should eq(2)
    end

    it "#hmget" do
      redis.del("myhash")
      redis.hset("myhash", "a", "123")
      redis.hset("myhash", "b", "456")
      redis.hmget("myhash", "a", "b").should eq(["123", "456"])
    end

    it "#hmset" do
      redis.del("myhash")
      redis.hmset("myhash", {"field1": "a", "field2": 2})
      redis.hget("myhash", "field1").should eq("a")
      redis.hget("myhash", "field2").should eq("2")
    end

    describe "#hscan" do
      it "no options" do
        redis.del("myhash")
        redis.hmset("myhash", {"field1": "a", "field2": "b"})
        new_cursor, keys = redis.hscan("myhash", 0)
        new_cursor.should eq("0")
        keys.should eq(["field1", "a", "field2", "b"])
      end

      it "with match" do
        redis.del("myhash")
        redis.hmset("myhash", {"foo": "a", "bar": "b"})
        new_cursor, keys = redis.hscan("myhash", 0, "f*")
        new_cursor.should eq("0")
        keys.is_a?(Array).should be_true
        # {foo:a} is matched, and Redis returns the key and val as a single list
        array(keys).should eq(["foo", "a"])
      end

      pending "hscan doesn't handle COUNT strictly" do
        it "#hscan with match and count" do
        end
      end

      it "with match and count at once" do
        redis.del("myhash")
        redis.hmset("myhash", {"foo": "a", "bar": "b", "baz": "c"})
        new_cursor, keys = redis.hscan("myhash", 0, "*a*", 1024)
        new_cursor.should eq("0")
        keys.is_a?(Array).should be_true
        # extract odd elements for keys because hscan returns (key, val) as a single list
        keys = array(keys).in_groups_of(2).map(&.first.not_nil!)
        keys.sort.should eq(["bar", "baz"])
      end
    end

    it "#hsetnx" do
      redis.del("myhash")
      redis.hsetnx("myhash", "foo", "setnxed").should eq(1)
      redis.hget("myhash", "foo").should eq("setnxed")
      redis.hsetnx("myhash", "foo", "setnxed2").should eq(0)
      redis.hget("myhash", "foo").should eq("setnxed")
    end

    it "#hvals" do
      redis.del("myhash")
      redis.hset("myhash", "a", "123")
      redis.hset("myhash", "b", "456")
      redis.hvals("myhash").should eq(["123", "456"])
    end
  end
end
