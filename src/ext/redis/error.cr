require "redis"

class Redis::Error
  class Moved < Redis::Error
    property slot
    property to

    def initialize(@slot : Int32, @to : String)
      super("MOVED #{@slot} #{@to}")
    end
  end

  class Ask < Redis::Error
    property slot
    property to

    def initialize(@slot : Int32, @to : String)
      super("ASK #{@slot} #{@to}")
    end
  end
end

# original instance creation
def Redis::Error.new0(s : String)
  err = Redis::Error.allocate
  err.initialize(s)
  err
end

# override for Moved and Ask
def Redis::Error.new(s)
  case s
  when /\AMOVED (\d+) (\S+)/
    Redis::Error::Moved.new($1.to_i32, $2)
  when /\AASK (\d+) (\S+)/
    Redis::Error::Ask.new($1.to_i32, $2)
  else
    new0(s)
  end
end
