# Hybrid client for standard or clustered
class ::Redis::Client
  @redis : ::Redis | ::Redis::Cluster::Client | Nil

  getter host, port, password
  getter! redis
  
  def initialize(uri : String)
    b = ::Redis::Cluster::Bootstrap.parse(uri)
    initialize(host: b.host, port: b.port, password: b.pass)
  end

  def initialize(@host : String, @port : Int32, @password : String? = nil)
  end

  def cluster?
    @redis.is_a?(::Redis::Cluster::Client)
  end
  
  def cluster
    @redis.as(::Redis::Cluster::Client)
  end
  
  def standard?
    @redis.is_a?(::Redis)
  end
  
  def standard
    @redis.as(::Redis)
  end
  
  protected def reconnect?(err : Exception)
    case err
    when Errno
      true
    else
      false
    end
  end
  
  macro method_missing(call)
    begin
      @redis ||= connect!
      @redis.not_nil!.{{call.id}}
      
    rescue err
      if reconnect?(err)
        @redis.try(&.close) rescue nil
        @redis = nil
      end
      raise err
    end
  end

  # Return a Cluster Connection or Standard Connection
  private def connect!
    redis = ::Redis.new(@host, @port, password: @password)

    begin
      redis.command(["cluster", "myid"])
    rescue e : ::Redis::Error
      if /This instance has cluster support disabled/ === e.message
        return redis
      else
        # Just raise it because it would be a connection problem like AUTH error.
        raise e
      end
    end

    return ::Redis::Cluster.new("#{@host}:#{@port}", password: @password)
  end
end
