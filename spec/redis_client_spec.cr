require "./spec_helper"

describe Redis::Client do
  describe ".new" do
    it "build instance from bootstrap object" do
      b = Bootstrap.new
      client = Redis::Client.new(b)
      client.host.should eq(b.host)
      client.port.should eq(b.port)
      client.unixsocket.should eq(b.sock)
      client.password.should eq(b.pass)
    end

    it "build instance from bootstrap object with unixsocket" do
      b = Bootstrap.new(sock: "/tmp/s")
      client = Redis::Client.new(b)
      client.host.should eq(b.host)
      client.port.should eq(b.port)
      client.unixsocket.should eq("/tmp/s")
      client.password.should eq(b.pass)

      # with auth
      b = Bootstrap.new(sock: "/tmp/s", pass: "secret")
      client = Redis::Client.new(b)
      client.host.should eq(b.host)
      client.port.should eq(b.port)
      client.unixsocket.should eq("/tmp/s")
      client.password.should eq("secret")
    end
  end

  describe ".boot" do
    it "build instance from bootstrap string" do
      client = Redis::Client.boot("127.0.0.1:6379")
      client.host.should eq("127.0.0.1")
      client.port.should eq(6379)
      client.unixsocket.should eq(nil)
      client.password.should eq(nil)
    end
  end

  describe "#bootstrap" do
    it "can show its connection info as bootstrap" do
      # from bootstrap
      bootstrap = Bootstrap.parse("127.0.0.1:6379")
      client = Redis::Client.new(bootstrap)
      client.bootstrap.should eq(bootstrap)

      # from string
      client = Redis::Client.new(port: 7000)
      client.bootstrap.port.should eq(7000)

      # with auth
      client = Redis::Client.new(password: "secret")
      client.bootstrap.password.should eq("secret")

      # unix socket
      client = Redis::Client.new(unixsocket: "/tmp/s")
      client.bootstrap.unixsocket.should eq("/tmp/s")

      # unix socket with auth
      client = Redis::Client.new(unixsocket: "/tmp/s", password: "secret")
      client.bootstrap.unixsocket.should eq("/tmp/s")
      client.bootstrap.password.should eq("secret")
    end
  end

  ######################################################################
  ### Testing with standard redis

  version = redis_version
  cluster_support = (version.split(".",3).map(&.to_i) <=> [3,0,0]) == 1

  unless cluster_support
    pending "Travis has old redis(#{version}), so it can't handle 'cluster' commands" do
    end
  end

  if cluster_support
  describe "#redis" do
    it "returns a Redis instance" do
      client = Redis::Client.new
      client.redis.should be_a(Redis)
      client.close
    end
  end

  describe "#cluster?" do
    it "returns false" do
      client = Redis::Client.new
      client.cluster?.should be_false
      client.close
    end
  end  

  describe "#cluster" do
    it "should raise" do
      client = Redis::Client.new
      expect_raises(Exception, "This instance has cluster support disabled: redis://127.0.0.1:6379") do
        client.cluster
      end
      client.close
    end
  end  

  describe "#standard?" do
    it "returns true" do
      client = Redis::Client.new
      client.standard?.should be_true
      client.close
    end
  end  

  describe "#standard" do
    it "returns redis instance" do
      client = Redis::Client.new
      client.standard.class.should eq(Redis)
      client.close
    end
  end
  end # end if cluster_support
end
