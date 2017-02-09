require "../spec_helper"

describe "Redis(ext)" do
  it "(setup)" do
    redis = Redis.new
    redis.flushall
    6.times{|i| redis.set(i.to_i, i.to_i)}
    3.times{|i| redis.sadd("set", i.to_i)}
    redis.close
  end

  describe "#each" do
    it "works" do
      array = [] of String

      redis = Redis.new
      redis.each do |key|
        array << key
      end
      redis.close

      array.sort.should eq(["0", "1", "2", "3", "4", "5", "set"])
    end

    it "works with count" do
      array = [] of String

      redis = Redis.new
      redis.each(count: 3) do |key|
        array << key
      end
      redis.close

      array.sort.should eq(["0", "1", "2", "3", "4", "5", "set"])
    end
  end

  describe "#each_keys" do
    it "works" do
      array = [] of String

      redis = Redis.new
      redis.each_keys do |keys|
        array += keys
      end
      redis.close

      array.sort.should eq(["0", "1", "2", "3", "4", "5", "set"])
    end

    it "works with count" do
      array = [] of String

      redis = Redis.new
      redis.each_keys(count: 3) do |keys|
        array += keys
      end
      redis.close

      array.sort.should eq(["0", "1", "2", "3", "4", "5", "set"])
    end
  end
end
