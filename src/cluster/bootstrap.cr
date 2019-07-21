require "uri"

module Redis::Cluster
  record Bootstrap,
    host : String? = nil,
    port : Int32?  = nil,
    sock : String? = nil,
    pass : String? = nil do

    def host
      if @host && @host =~ /:/
        raise "invalid hostname: #{@host}"
      end
      @host || "127.0.0.1"
    end
         
    def port
      @port || 6379
    end
         
    def sock?
      !! @sock
    end

    def pass? : String?
      # empty string should be treated as nil for redis password
      @pass.to_s.empty? ? nil : @pass.to_s
    end

    # aliases
    def pass       ; pass? ; end
    def password   ; pass  ; end
    def unixsocket ; sock  ; end
         
    def copy(host : String? = nil, port : Int32? = nil, sock : String? = nil, pass : String? = nil)
      Bootstrap.new(host: host||@host, port: port||@port, sock: sock||@sock, pass: pass||pass?)
    end

    def redis
      Redis.new(host: host, port: port, unixsocket: @sock, password: @pass)
    rescue err : Redis::CannotConnectError
      if sock?
        raise Redis::CannotConnectError.new("file://#{@sock}")
      else
        raise err
      end
    end

    def to_s(secure = true)
      auth = nil
      auth = "#{pass}@" if pass
      auth = "[FILTERED]@" if pass && secure

      if sock?
        "redis://%s%s" % [auth, sock]
      else
        "redis://%s%s:%s" % [auth, host, port]
      end
    end

    def to_s(io : IO)
      io << to_s
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
      # `URI.parse("redis:///")` now builds `host` as `""` rather than `nil` (#6323 in crystal-0.29)
      host = uri.host.to_s.empty? ? nil : uri.host.to_s
      pass = uri.user.to_s.empty? ? nil : uri.user
      path = uri.path.to_s.empty? ? nil : uri.path.to_s

      if path && host.nil? && uri.port.nil?
        return new(sock: path, pass: pass)
      end
      if uri.port && uri.port.not_nil! <= 0
        raise "invalid port for Bootstrap: `#{uri.port}`"
      end
      zero.copy(host: host, port: uri.port, pass: pass)
    end
  end
end
