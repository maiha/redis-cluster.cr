struct Redis::Cluster::NodeInfo
  def self.parse(line : String) : Redis::Cluster::NodeInfo
    # 2afb4da9d68942a32676ca19e77492c4ba921d0f 127.0.0.1:7001 myself,master - 0 0 1 connected 0-5460
    # 56f1954c1fa7b63fb631a872480dbf0a93bc8a9a 127.0.0.1:7004 slave 2afb4da9d68942a32676ca19e77492c4ba921d0f 0 1466089461937 1 connected
    ary = line.split
    argc = 0
    shift = ->(){
      if ary[0]?
        argc += 1
        ary.shift
      else
        raise "node format error: expected data[#{argc}], but missing. `#{line}'"
      end
    }
           
    sha1   = shift.call
    addr   = shift.call
    flags  = shift.call
    master = shift.call.sub(/^-$/, "")
    sent   = shift.call
    recv   = shift.call
    epoch  = shift.call
    status = shift.call
    slot   = Slot.parse(ary.join(","))

    addr = Addr.parse(addr)
    
    return Redis::Cluster::NodeInfo.new(sha1: sha1, addr: addr, flags: flags, master: master, sent: sent.to_i64, recv: recv.to_i64, epoch: epoch.to_i64, status: status, slot: slot)
  end

  def self.array_parse(buf : String, strict = false) : Array(Redis::Cluster::NodeInfo)
    nodes = [] of Redis::Cluster::NodeInfo
    buf.each_line do |line|
      case line
      when /^[0-9a-f]{4}/       # valid node
        nodes << Redis::Cluster::NodeInfo.parse(line.chomp)
      else
        raise "unexpected node format: #{line}" if strict
      end
    end
    return nodes.sort_by(&.addr)
  end
end
