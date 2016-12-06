require "./spec_helper"

describe "reset!" do
  it "should be called when non served slot is used" do
    info = load_cluster_info("nodes/slot0-6379.nodes")
    cluster = new_redis_cluster(info)

    # Using unbound slot will call reset! which sends cluster command.
    # Then, got a cluster error because standard redis is running.
    expect_raises(Redis::Error, /cluster support disabled/) do
      cluster.addr("3194")
    end
    cluster.close
  end
end
