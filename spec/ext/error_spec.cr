require "../spec_helper"

describe Redis::Error do
  describe ".new(MOVED)" do
    it "should build Moved error" do
      error = Redis::Error.new("MOVED 12182 127.0.0.1:7001")
      error.should be_a(Redis::Error::Moved)

      error = error.as(Redis::Error::Moved)
      error.slot.should eq(12182)
      error.to.should eq("127.0.0.1:7001")
    end
  end
end
