module Redis::Cluster
  def self.load_info(bootstraps : Array(Bootstrap), pass = nil) : ClusterInfo
    bootstraps = bootstraps.map(&.copy(pass: pass)) # merge password
    errors = [] of Exception
    bootstraps.each do |bootstrap|
      redis = nil
      begin
        redis = bootstrap.redis
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
    raise "Redis not found: #{bootstraps.map(&.to_s).inspect}"
  end
end
