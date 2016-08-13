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

  macro proxy(name, *args)
    def {{ name.id }}({{ args.join(",").id }})
      redis(key.to_s).{{ name.id }}({{ args.join(",").id }})
    rescue moved : Redis::Error::Moved
      on_moved(moved)
      redis(key.to_s).{{ name.id }}({{ args.join(",").id }})
    rescue ask : Redis::Error::Ask
      redis(Addr.parse(ask.to)).{{ name.id }}({{ args.join(",").id }})
    rescue err : Errno
      redis(key.to_s).{{ name.id }}({{ args.join(",").id }})
    end
  end

  macro proxy_ary(name, *args)
    def {{ name.id }}({{ args.join(",").id }})
      key = {{args.first}}.first { raise "{{name}}: key not found" }
      begin
        redis(key.to_s).{{ name.id }}({{ args.join(",").id }})
      rescue moved : Redis::Error::Moved
        on_moved(moved)
        redis(key.to_s).{{ name.id }}({{ args.join(",").id }})
      rescue ask : Redis::Error::Ask
        redis(Addr.parse(ask.to)).{{ name.id }}({{ args.join(",").id }})
      rescue err : Errno
        redis(key.to_s).{{ name.id }}({{ args.join(",").id }})
      end
    end
  end
end
