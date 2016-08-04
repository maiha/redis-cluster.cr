module Redis::Cluster
  def self.load_info(addrs : Array(Addr), pass = nil) : ClusterInfo
    errors = [] of Exception
    addrs.each do |addr|
      redis = nil
      begin
        redis = Redis.new(host: addr.host, port: addr.port, password: pass)
        return ClusterInfo.parse(redis.not_nil!.nodes)
      rescue err
        # #<Errno:0xd37a40 @message="Error connecting to '127.0.0.1:7001': Connection refused"
        errors << err
      ensure
        redis.try(&.close)
      end
    end
    if errors.any?
      raise errors.first.not_nil!
    end
    raise "Redis not found: #{addrs.map(&.to_s).inspect}"
  end
end
