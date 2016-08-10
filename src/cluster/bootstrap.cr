require "uri"

module Redis::Cluster
  record Bootstrap,
    host : String,
    port : Int32,
    pass : String? do

    def self.zero
      new(host: Addr::DEFAULT_HOST, port: Addr::DEFAULT_PORT, pass: nil)
    end

    def self.parse(s : String)
      case s
      when %r{\Aredis://}
        # normalized
      when %r{\A([a-z0-9\.\+-]+):/}
        raise "unknown scheme for Bootstrap: `#{$1}`"
      else
        s = "redis://#{s}"
      end
        
      uri = URI.parse(s)
      if uri.port && uri.port.not_nil! <= 0
        raise "invalid port for Bootstrap: `#{uri.port}`"
      end
      host = uri.host.to_s.empty? ? nil : uri.host
      zero.copy(host: host, port: uri.port, pass: uri.user)
    end
         
    def copy(host : String? = nil, port : Int32? = nil, pass : String? = nil)
      Bootstrap.new(host: host||@host, port: port||@port, pass: pass||@pass)
    end

    def redis
      Redis.new(host: @host, port: @port, password: @pass)
    end
  end
end
