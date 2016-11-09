require "./spec_helper"

describe "Redis" do
  describe "version" do
    version = redis_version
    it "'#{version}' > 2.8.0" do
      (version.split(".",3).map(&.to_i) <=> [2,8,0]).should eq(1)
    end
  end
end
