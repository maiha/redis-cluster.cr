module Redis::Cluster::Pool
  include Enumerable(Redis)     # for all redis connections

  def new_redis(host : String, port : Int32)
    Redis.new(host: host, port: port, password: @password)
  end
  
  def redis(key : String)
    ready!
    redis(addr(key))
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

  private def addr(key : String)
    slot = Slot.slot(key)
    return @slot2addr.fetch(slot) { raise "This cluster doesn't cover slot=#{slot} (key=#{key.inspect})" }
  end
end
