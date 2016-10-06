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
end
