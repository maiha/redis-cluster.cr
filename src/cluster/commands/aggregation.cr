module Redis::Cluster::Commands
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
end
