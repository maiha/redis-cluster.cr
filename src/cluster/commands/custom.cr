module Redis::Cluster::Commands

  ######################################################################
  ### Keys

  def keys(pattern)
    array = [] of String
    nodes.each do |n|
      array += redis(n.addr).keys(pattern)
    end
    return array
  end

  def randomkey
    nodes.select(&.is_master).each{|n|
      key = redis(n.addr).randomkey
      return key if key
    }
    return nil
  end

  ######################################################################
  ### Connection

  # This is not clustered command. Just send to first node
  def ping
    # crc16("3B8") -> 0
    redis("3B8").ping
  end

  ######################################################################
  ### Server

  def flushall
    nodes.select(&.is_master).map{|n|
      redis(n.addr).flushall
    }
  end

  ######################################################################
  ### Lists

  ######################################################################
  ### Sets

  ######################################################################
  ### Strings

  ######################################################################
  ### Aggregate

  # **Return value**: -1 when redis level error
  def counts : Counts
    nodes.reduce(Counts.new) do |h, n|
      h[n] = (redis(n.addr).count rescue -1.to_i64)
      h
    end
  end

  # **Return value**: error message is stored in value when redis level error
  def info(field : String = "v,cnt,m,d")
    nodes.reduce(Hash(NodeInfo, Array(InfoExtractor::Value)).new) do |hash, node|
      begin
        info = InfoExtractor.new(redis(node.addr).info)
        keys = field.split(",").map(&.strip)
        hash[node] = keys.map{|k| info.extract(k)}
      rescue err
        hash[node] = [err.to_s.as(InfoExtractor::Value)]
      end
      hash
    end
  end

  def raw_info
    nodes.reduce(Hash(NodeInfo, Hash(String, String)).new) do |hash, node|
      hash[node] = redis(node.addr).info
      hash
    end
  end
end
