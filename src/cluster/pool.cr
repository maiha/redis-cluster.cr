module Redis::Cluster::Pool
  include Enumerable(Redis)     # for all redis connections

  def new_redis(host : String, port : Int32)
    Redis.new(host: host, port: port, password: password)
  end
  
  def redis(key : String)
    redis(addr(key))
  end

  def redis(node : NodeInfo)
    redis(node.addr)
  end

  def each
    cluster_info.nodes.each do |n|
      yield redis(n)
    end
  end
  
  def cover_slot?(slot)
    !! @slot2addr[slot]?
  end

  def close
    @addr2redis.values.each(&.close)
    @addr2redis.clear
  end

  private def redis(addr : Addr)
    @addr2redis[addr] ||= new_redis(addr.host, addr.port)
  end

  private def reconnect_redis(addr : Addr)
    @addr2redis[addr]?.try(&.close)
    @addr2redis[addr] = new_redis(addr.host, addr.port)
  end

  def addr(key : String)
    ready!
    slot = Slot.slot(key)
    return @slot2addr.fetch(slot) { raise "This cluster doesn't cover slot=#{slot} (key=#{key.inspect})" }
  end

  # public method : for spec
  def on_moved(moved : Redis::Error::Moved)
    @slot2addr[moved.slot] = Addr.parse(moved.to)
  end

  def on_disconnected(key : String, error)
    reconnect_redis(addr(key))
  end
end
