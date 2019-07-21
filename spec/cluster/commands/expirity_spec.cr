require "./spec_helper"

describe "Commands" do
  describe "expiry" do
    it "#expire" do
      redis.set("temp", "3")
      redis.expire("temp", 2).should eq(1)
    end

    it "#expireat" do
      redis.set("temp", "3")
      redis.expireat("temp", 1555555555005).should eq(1)
      redis.ttl("temp").should be > 3000
    end

    it "#ttl" do
      redis.set("temp", "9")
      redis.ttl("temp").should eq(-1)
      redis.expire("temp", 3)
      redis.ttl("temp").should eq(3)
    end

    it "#pexpire" do
      redis.set("temp", "3")
      redis.pexpire("temp", 1000).should eq(1)
    end

    it "#pexpireat" do
      redis.set("temp", "3")
      redis.pexpireat("temp", 2555555555005).should eq(1) # 2050-12-25
      redis.pttl("temp").should be > 86400*365            # At least one year later
    end

    it "#pttl" do
      redis.set("temp", "9")
      redis.pttl("temp").should eq(-1)
      redis.pexpire("temp", 3000)
      redis.pttl("temp").should be > 2990
    end

    it "#persist" do
      redis.set("temp", "9")
      redis.expire("temp", 3)
      redis.ttl("temp").should eq(3)
      redis.persist("temp")
      redis.ttl("temp").should eq(-1)
    end
  end
end
