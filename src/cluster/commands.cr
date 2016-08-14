module Redis::Cluster::Commands
  abstract def redis(key : String) : Redis

  # [proxy] macro
  # "proxy get, key" generates
  #
  # def get(key)
  #   redis(key).get(key)
  # rescue moved : Redis::Error::Moved
  #   on_moved(moved)
  #   redis(key).get(key)
  # rescue ask : Redis::Error::Ask
  #   redis(Addr.parse(ask.to)).get(key)
  # end

  # `proxy` macro
  # [input]
  #   proxy set, key, value, ex = nil, px = nil, nx = nil, xx = nil
  # [output]
  #   def set(key, value, ex = nil, px = nil, nx = nil, xx = nil)
  #     redis(key.to_s).set(key, value, ex: ex, px: px, nx: nx, xx: xx)
  #   rescue moved : Redis::Error::Moved
  #     on_moved(moved)
  #     redis(key.to_s).set(key, value, ex: ex, px: px, nx: nx, xx: xx)
  #   rescue ask : Redis::Error::Ask
  #     redis(Addr.parse(ask.to)).set(key, value, ex: ex, px: px, nx: nx, xx: xx)
  #   rescue err : Errno
  #     redis(key.to_s).set(key, value, ex: ex, px: px, nx: nx, xx: xx)
  #   end
  macro proxy(name, *args)
    {% named_args = args.map{|a| a.is_a?(Assign) ? "#{a.target}: #{a.target}" : a.is_a?(TypeDeclaration) ? a.var : a}.join(", ").id %}
    {% invoke = "#{name}(#{named_args})".id %}
    def {{ name.id }}({{ args.join(", ").id }})
      redis(key.to_s).{{ invoke }}
    rescue moved : Redis::Error::Moved
      on_moved(moved)
      redis(key.to_s).{{ invoke }}
    rescue ask : Redis::Error::Ask
      redis(Addr.parse(ask.to)).{{ invoke }}
    rescue err : Errno
      redis(key.to_s).{{ invoke }}
    end
  end

  macro proxy_ary(name, *args)
    {% named_args = args.map{|a| a.is_a?(Assign) ? "#{a.target}: #{a.target}" : a}.join(", ").id %}
    {% invoke = "#{name}(#{named_args})".id %}
    def {{ name.id }}({{ args.join(",").id }})
      key = {{args.first}}.first { raise "{{name}}: key not found" }
      begin
        redis(key.to_s).{{ invoke }}
      rescue moved : Redis::Error::Moved
        on_moved(moved)
        redis(key.to_s).{{ invoke }}
      rescue ask : Redis::Error::Ask
        redis(Addr.parse(ask.to)).{{ invoke }}
      rescue err : Errno
        redis(key.to_s).{{ invoke }}
      end
    end
  end

  # Use first key to resolve node
  macro proxy_hash(name, *args)
    {% named_args = args.map{|a| a.is_a?(Assign) ? "#{a.target}: #{a.target}" : a}.join(", ").id %}
    {% invoke = "#{name}(#{named_args})".id %}
    def {{ name.id }}({{ args.join(",").id }})
      h = {{args.first}}        # h is a (Hash | NamedTuple)
      raise "{{name}}: key not found" if h.empty?
      key = h.keys.first       # for first key
      begin
        redis(key.to_s).{{ invoke }}
      rescue moved : Redis::Error::Moved
        on_moved(moved)
        redis(key.to_s).{{ invoke }}
      rescue ask : Redis::Error::Ask
        redis(Addr.parse(ask.to)).{{ invoke }}
      rescue err : Errno
        redis(key.to_s).{{ invoke }}
      end
    end
  end
end
