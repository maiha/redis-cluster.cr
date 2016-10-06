require "uri"

module Redis::Cluster
  record Bootstrap,
    host : String? = nil,
    port : Int32?  = nil,
    sock : String? = nil,
    pass : String? = nil do

    def host
      @host || "127.0.0.1"
    end
         
    def port
      @port || 6379
    end
         
    def sock?
      !! @sock
    end
         
    def copy(host : String? = nil, port : Int32? = nil, sock : String? = nil, pass : String? = nil)
      Bootstrap.new(host: host||@host, port: port||@port, sock: sock||@sock, pass: pass||@pass)
    end

    def redis
      Redis.new(host: host, port: port, unixsocket: @sock, password: @pass)
    end

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
      if uri.path && uri.host.nil? && uri.port.nil?
        return new(sock: uri.path, pass: uri.user)
      end
      if uri.port && uri.port.not_nil! <= 0
        raise "invalid port for Bootstrap: `#{uri.port}`"
      end
      host = uri.host.to_s.empty? ? nil : uri.host
      zero.copy(host: host, port: uri.port, pass: uri.user)
    end
  end
end
