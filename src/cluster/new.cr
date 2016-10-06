module Redis::Cluster
  # current api
  def self.new(bootstrap : Bootstrap) : Client
    Client.new(bootstrap)
  end

  # [backward compats]
  def self.new(bootstrap : String, password : String? = nil) : Client
    bootstraps = bootstrap.split(",").map{|b| Bootstrap.parse(b.strip).copy(pass: password)}
    Client.new(bootstraps)
  end

  # Return a Cluster Connection or Standard Connection
  def self.connect(host : String, port : Int32, password : String? = nil) : Connection
    redis = ::Redis.new(host, port, password: password)

    begin
      redis.command(["cluster", "myid"])
    rescue e : Redis::Error
      if /This instance has cluster support disabled/ === e.message
        return redis
      else
        # Just raise it because it would be a connection problem like AUTH error.
        raise e
      end
    end

    return ::Redis::Cluster.new("#{host}:#{port}", password: password)
  end
end
