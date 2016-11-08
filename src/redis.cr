# Hybrid client for standard or clustered
class ::Redis::Client
  @redis : ::Redis | ::Redis::Cluster::Client | Nil

  delegate host, port, unixsocket, password, to: @bootstrap
  getter bootstrap

  def self.boot(bootstrap : String)
    new(::Redis::Cluster::Bootstrap.parse(bootstrap))
  end

  def initialize(@bootstrap : ::Redis::Cluster::Bootstrap)
  end

  # compats with `::Redis.new`
  def initialize(host : String? = nil, port : Int32? = nil, unixsocket : String? = nil, password : String? = nil)
    initialize(::Redis::Cluster::Bootstrap.new(host: host, port: port, sock: unixsocket, pass: password))
  end

  def redis
    connect!
    @redis.not_nil!
  end

  def cluster?
    redis.is_a?(::Redis::Cluster::Client)
  end
  
  def cluster
    redis.tap{ |r|
      raise "This instance has cluster support disabled: #{bootstrap}" unless r.is_a?(::Redis::Cluster::Client)
    }.as(::Redis::Cluster::Client)
  end
  
  def standard?
    redis.is_a?(::Redis)
  end
  
  def standard
    redis.tap{ |r|
      raise "This instance is running on cluster: #{bootstrap}" unless r.is_a?(::Redis)
    }.as(::Redis)
  end

  ######################################################################
  ### Hybrid feature

  def redis_for(key : String)
    cluster? ? cluster.redis(key) : standard
  end

  def multi(key)
    (cluster? ? cluster.redis(key) : standard).multi do |multi|
      yield(multi)
    end
  end

  protected def reconnect?(err : Exception)
    case err
    when Errno
      true
    else
      false
    end
  end
  
  def connect!
    @redis ||= establish_connection!
  end

  def close!
    @redis.try(&.close) rescue nil
    @redis = nil
  end
  
  ######################################################################
  ### Connection

  # Return a Cluster Connection or Standard Connection
  private def establish_connection!
    redis = bootstrap.redis

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

    return ::Redis::Cluster.new(bootstrap)
  end

  macro method_missing(call)
    begin
      redis.{{call.id}}
    rescue err
      close! if reconnect?(err)
      raise err
    end
  end
end
