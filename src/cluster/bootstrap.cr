require "uri"
require "openssl"

module Redis::Cluster
  record Bootstrap,
    host : String? = nil,
    port : Int32?  = nil,
    sock : String? = nil,
    pass : String? = nil,
    ssl  : Bool = false,
    ssl_context  : OpenSSL::SSL::Context::Client? = nil do

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
         
    def copy(host : String? = nil, port : Int32? = nil, sock : String? = nil, pass : String? = nil, ssl : Bool = false,ssl_context : OpenSSL::SSL::Context::Client? = nil)
      Bootstrap.new(host: host||@host, port: port||@port, sock: sock||@sock, pass: pass||pass?, ssl: ssl||@ssl, ssl_context: ssl_context||@ssl_context)
    end

    def redis
      Redis.new(host: host, port: port, unixsocket: @sock, password: @pass, ssl: @ssl, ssl_context: @ssl_context)
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
      ssl = false
      case s
      when %r{\Aredis://}
        # normalized
      when %r{\Arediss://}
        # normalized
        ssl = true
      when %r{\A([a-z0-9\.\+-]+):/}
        raise "unknown scheme for Bootstrap: `#{$1}`"
      else
        s = "redis://#{s}"
      end
        
      uri = URI.parse(s)
      pass = uri.user
      pass = nil if pass.to_s.empty?
      if uri.path && uri.host.nil? && uri.port.nil?
        return new(sock: uri.path, pass: pass, ssl: ssl)
      end
      if uri.port && uri.port.not_nil! <= 0
        raise "invalid port for Bootstrap: `#{uri.port}`"
      end
      host = uri.host.to_s.empty? ? nil : uri.host
      zero.copy(host: host, port: uri.port, pass: pass, ssl: ssl)
    end
  end
end
