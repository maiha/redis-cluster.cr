require "./spec_helper"

describe Redis::Cluster::Commands do
  it "#[]?" do
    Redis::Cluster::Commands["get"]?.should be_true
    Redis::Cluster::Commands["GET"]?.should be_true
    Redis::Cluster::Commands[:get ]?.should be_true
    Redis::Cluster::Commands["foo"]?.should be_false
  end
end
