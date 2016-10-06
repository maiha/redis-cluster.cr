require "./spec_helper"

private def bootstrap(host = nil, port = nil, sock = nil, pass = nil)
  Redis::Cluster::Bootstrap.new(host, port, sock, pass)
end

private def parse(string) : Redis::Cluster::Bootstrap
  Redis::Cluster::Bootstrap.parse(string)
end

describe Redis::Cluster::Bootstrap do
  describe "#to_s" do
    it "should normalize uri" do
      bootstrap.to_s.should eq("redis://127.0.0.1:6379")
      bootstrap.to_s(secure: false).should eq("redis://127.0.0.1:6379")
    end

    it "should filter password in default" do
      bootstrap(pass: "secret").to_s.should eq("redis://[FILTERED]@127.0.0.1:6379")
    end

    it "should show password with secure = false option" do
      bootstrap(pass: "secret").to_s(secure: false).should eq("redis://secret@127.0.0.1:6379")
    end

    it "should works with sock" do
      bootstrap(sock: "/tmp/s").to_s.should eq("redis:///tmp/s")
      bootstrap(sock: "/tmp/s", pass: "secret").to_s.should eq("redis://[FILTERED]@/tmp/s")
      bootstrap(sock: "/tmp/s", pass: "secret").to_s(secure: false).should eq("redis://secret@/tmp/s")
    end
  end

  describe "equality" do
    it "should test by value" do
      bootstrap("a",1).should eq(bootstrap("a",1))
      bootstrap("a",1).should_not eq(bootstrap("a",2))
      bootstrap("a",1).should_not eq(bootstrap("b",1))

      bootstrap("a",1,"p").should eq(bootstrap("a",1,"p"))
      bootstrap("a",1,"p").should_not eq(bootstrap("a",1))
      bootstrap("a",1,"p").should_not eq(bootstrap("a",2,"p"))
      bootstrap("a",1,"p").should_not eq(bootstrap("b",1,"p"))
    end
  end

  describe ".parse" do
    it "should treat a empty host as 127.0.0.1" do
      parse(":7001").host.should eq("127.0.0.1")
    end

    it "should treat a empty port as 6379" do
      parse("localhost").port.should eq(6379)
    end

    it "should treat a empty password as is" do
      parse("localhost:6379").pass.should eq(nil)
    end

    it "should build default setting from empty string" do
      parse("").should eq(bootstrap("127.0.0.1", 6379))
    end

    it "should accept uri with protocol" do
      # host, port
      parse("redis://a@host:1").should eq(bootstrap("host"     , 1   , pass: "a"))
      parse("redis://a@host:1").should eq(bootstrap("host"     , 1   , pass: "a"))
      parse("redis://a@host"  ).should eq(bootstrap("host"     , 6379, pass: "a"))
      parse("redis://a@:1"    ).should eq(bootstrap("127.0.0.1", 1   , pass: "a"))
      parse("redis://host:1"  ).should eq(bootstrap("host"     , 1   , pass: nil))
      parse("redis://host"    ).should eq(bootstrap("host"     , 6379, pass: nil))
      parse("redis://a@"      ).should eq(bootstrap("127.0.0.1", 6379, pass: "a"))
      parse("redis://:1"      ).should eq(bootstrap("127.0.0.1", 1   , pass: nil))
      # sock
      parse("redis:///tmp/s"  ).should eq(bootstrap(sock: "/tmp/s"))
      parse("redis://a@/tmp/s").should eq(bootstrap(sock: "/tmp/s", pass: "a"))
    end

    it "should accept uri without protocol" do
      # host, port
      parse("a@host:1").should eq(bootstrap("host"     , 1   , pass: "a"))
      parse("a@host:1").should eq(bootstrap("host"     , 1   , pass: "a"))
      parse("a@host"  ).should eq(bootstrap("host"     , 6379, pass: "a"))
      parse("a@:1"    ).should eq(bootstrap("127.0.0.1", 1   , pass: "a"))
      parse("host:1"  ).should eq(bootstrap("host"     , 1   , pass: nil))
      parse("host"    ).should eq(bootstrap("host"     , 6379, pass: nil))
      parse("a@"      ).should eq(bootstrap("127.0.0.1", 6379, pass: "a"))
      parse(":1"      ).should eq(bootstrap("127.0.0.1", 1   , pass: nil))
      # sock
      parse("/tmp/s"  ).should eq(bootstrap(sock: "/tmp/s"))
      parse("a@/tmp/s").should eq(bootstrap(sock: "/tmp/s", pass: "a"))
    end

    it "should raise when port part is not number nor positive" do
      expect_raises(Exception, /port/) do
        parse("127.0.0.1:x")
      end

      expect_raises(Exception, /port/) do
        parse("127.0.0.1:0")
      end

      expect_raises(Exception, /port/) do
        parse("127.0.0.1:-1")
      end
    end

    it "should raise when non 'redis' schema is given" do
      expect_raises(Exception, /scheme/) do
        parse("http://127.0.0.1")
      end
    end
  end

  describe "#copy" do
    a = bootstrap("a",1,"/tmp/s","SECRET")
    it "update host" do
      b = a.copy(host: "b")
      a.host.should eq("a")
      b.host.should eq("b")

      # by nil
      b = a.copy(host: nil)
      a.host.should eq("a")
      b.host.should eq("a")
    end

    it "update port" do
      b = a.copy(port: 2)
      a.port.should eq(1)
      b.port.should eq(2)

      # by nil
      b = a.copy(port: nil)
      a.port.should eq(1)
      b.port.should eq(1)
    end

    it "update sock" do
      b = a.copy(sock: "/tmp/b")
      a.sock.should eq("/tmp/s")
      b.sock.should eq("/tmp/b")

      # by nil
      b = a.copy(sock: nil)
      a.sock.should eq("/tmp/s")
      b.sock.should eq("/tmp/s")
    end

    it "update pass" do
      b = a.copy(pass: "PASS")
      a.pass.should eq("SECRET")
      b.pass.should eq("PASS")

      # by nil
      b = a.copy(pass: nil)
      a.pass.should eq("SECRET")
      b.pass.should eq("SECRET")
    end

    it "update multiple keys at once" do
      b = a.copy(host: "b", sock: "/tmp/b", pass: nil)
      b.host.should eq("b")
      b.port.should eq(a.port)
      b.sock.should eq("/tmp/b")
      b.pass.should eq(a.pass)
    end
  end

  describe "#redis" do
    it "should create redis connection" do
      b = Bootstrap.new(port: 6379)  # available in TravisCI
      b.redis.close # should work
    end

    it "should raise when redis is down" do
      b = Bootstrap.new(port: 6380)  # when redis is down
      expect_raises(Errno, /127.0.0.1:6380/) do
        b.redis
      end
    end

    it "should respect unixsocket parameter" do
      b = Bootstrap.new(sock: "/tmp/xxx.sock")

      # here, the error message depends on Crystal implementation (UNIXSocket#initialize)
      expect_raises(Errno, /xxx.sock': No such file or directory/) do
        b.redis
      end

      # Although we can't test to connect by socket itself, we can ensure the value will be used.
    end
  end
end
