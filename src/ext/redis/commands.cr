require "redis"

class Redis
  module Commands
    def myid
      string_command(["CLUSTER", "MYID"])
    end
    
    def nodes
      string_command(["CLUSTER", "NODES"])
    end
    
    def addslots(slots : Array(Int32))
      string_command(["CLUSTER", "ADDSLOTS"] + slots.map(&.to_s))
    end

    def meet(host : String, port : String)
      string_command(["CLUSTER", "MEET", host, port])
    end

    def replicate(master : String)
      string_command(["CLUSTER", "REPLICATE", master])
    end

    def failover
      string_command(["CLUSTER", "FAILOVER"])
    end

    def takeover
      string_command(["CLUSTER", "FAILOVER", "TAKEOVER"])
    end

    def count! : Int64
      integer_command(["DBSIZE"])
    end

    {% begin %}
    {% errno = (compare_versions(Crystal::VERSION, "0.34.0-0") > 0) ? "RuntimeError" : "Errno" %}
    def count? : Int64?
      count!
    rescue err : {{ errno.id }}
      # tcp down: #<Errno:0xd37a40 @message="Error connecting to '127.0.0.1:7001': Connection refused"
      nil
    end
    {% end %}

    def count(default = -1) : Int64
      count? || default.to_i64
    end
  end
end
