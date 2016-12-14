require "./spec_helper"

describe Redis::Cluster::ClusterInfo do
  info = Redis::Cluster::ClusterInfo.parse <<-EOF
    b3b2965 127.0.0.1:7001 myself,master - 0 0 2 connected 0-9990
    12acff8 127.0.0.1:7002 master - 0 1466253316377 1 connected 10000-16383
    bb6050b 127.0.0.1:7003 slave b3b2965 0 1466253315354 2 connected
    EOF

  describe "#active?" do
    zero = Redis::Cluster::Counts.new{ 0_i64 }

    it "return true when count = 0" do
      node = info.nodes.first
      info.active?(node, zero).should eq true
    end

    it "return true when count is nil" do
      node = info.nodes.first
      info.active?(node, Redis::Cluster::Counts.new).should eq false
    end
  end

  describe "#find_node_by" do
    it "long sha1" do
      info.find_node_by!("12acff8").port.should eq(7002)
    end

    it "short sha1" do
      info.find_node_by!("1").port.should eq(7002)
    end

    it "exact addr" do
      info.find_node_by!("127.0.0.1:7001").port.should eq(7001)
    end

    it "postfixed addr" do
      expect_raises(Redis::Cluster::ClusterInfo::NodeNotFound) do
        info.find_node_by!("0.0.1:7001")
      end
    end

    it "port" do
      info.find_node_by!(":7003").port.should eq(7003)
    end

    it "port without colon is considered as addr" do
      expect_raises(Redis::Cluster::ClusterInfo::NodeNotFound) do
        info.find_node_by!("7003")
      end
    end

    it "raises NodeNotUniq when multiple nodes have same sha1" do
      expect_raises(Redis::Cluster::ClusterInfo::NodeNotUniq) do
        info.find_node_by!("b")
      end
    end

    it "raises NodeNotUniq when multiple nodes have same host" do
      expect_raises(Redis::Cluster::ClusterInfo::NodeNotUniq) do
        info.find_node_by!("127.0")
      end
    end
  end

  it "#slave_deps" do
    deps = info.slave_deps
    deps.size.should eq(1)
    master, slaves = deps.first
    master.port.should eq(7001)
    slaves.map(&.port).should eq([7003])
  end

  it "#slaves_of" do
    # [master]       [slaves]
    # 127.0.0.1:7001 127.0.0.1:7003
    # 127.0.0.1:7002
    n1 = info.find_node_by!(":7001")
    n2 = info.find_node_by!(":7002")
    n3 = info.find_node_by!(":7003")
    info.slaves_of(n1).should eq([n3])
    info.slaves_of(n2).should eq(Array(NodeInfo).new)
  end

  it "#open_slots" do
    info.open_slots.should eq((9991..9999).to_a)
  end

  describe "(special states)" do
    it "parses signatures" do
      info = Redis::Cluster::ClusterInfo.parse <<-EOF
        2db26dd98c89a37be9a97ff4b87735c568efe535 127.0.0.1:7101 myself,master - 0 0 1 connected 0-1000 1500 2001-3000 [7->-c795516499b9b71b6ba0b14ca5202cea3dd27749]
        c795516499b9b71b6ba0b14ca5202cea3dd27749 127.0.0.1:7102 master - 0 1470757457132 0 connected
        EOF

      info.nodes.map(&.signature).should eq([
        "2db26dd98c89a37be9a97ff4b87735c568efe535:0-1000,1500,2001-3000",
        "c795516499b9b71b6ba0b14ca5202cea3dd27749:"
      ])
    end
  end

  describe "(broken data)" do
    it "works when slave has a missing master reference" do
      info = Redis::Cluster::ClusterInfo.parse <<-EOF
        b3b2965 127.0.0.1:7001 myself,master - 0 0 2 connected 0-9990
        bb6050b 127.0.0.1:7003 slave xyz 0 1466253315354 2 connected
        EOF
      info.nodes.map(&.addr.to_s).should eq(["127.0.0.1:7001", "127.0.0.1:7003"])
      info.slaves.map(&.addr.to_s).should eq(["127.0.0.1:7003"])
      info.slave_deps.size.should eq(0)
    end
  end

  describe "(with vars format)" do
    nodes = <<-EOF
      b3b2965 127.0.0.1:7001 myself,master - 0 0 2 connected 0-9990
      12acff8 127.0.0.1:7002 master - 0 1466253316377 1 connected 10000-16383
      xyz
      foo
      bb6050b 127.0.0.1:7003 slave b3b2965 0 1466253315354 2 connected
      vars currentEpoch 2 lastVoteEpoch 0
      EOF

    it "should ignore vars or unknown entry" do
      info = Redis::Cluster::ClusterInfo.parse(nodes)
      info.nodes.map(&.addr.port).sort.should eq([7001,7002,7003])
    end

    it "should raise when strict mode" do
      expect_raises(Exception, /xyz/) do
        Redis::Cluster::ClusterInfo.parse(nodes, strict: true)
      end
    end
  end

  describe "#each_nodes" do
    it "iterates master and slaves in series" do
      marks = [] of String

      info = load_cluster_info("nodes/m3s3o1.nodes")
      info.each_nodes do |node|
        marks << node_mark(node)
      end

      marks.should eq(["M", "S", "M", "S", "M", "S", "-"])
    end
  end
end
