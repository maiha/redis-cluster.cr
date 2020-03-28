module Redis::Cluster
  class Slot
    FIRST = 0
    LAST  = 16383
    RANGE = (FIRST..LAST)
    SIZE  = RANGE.size
    MASK  = 0x3FFF              # fast modulo for 16384

    DELIMITER = /[,\s]+/
    
    def self.zero
      Slot.new("", Set(Int32).new)
    end

    def self.slot(key : String) : Int32
      key = $1 if key =~ /{(.*?)}/
      (Crc16.crc16(key) & MASK).to_i32
    end

    def self.parse(str : String) : Slot
      str = str.strip
      case str
      when ""
        return Slot.zero
      when DELIMITER
        slots = str.split(DELIMITER).map{|s| parse(s.strip)}
        return slots.reduce(Slot.zero) {|a,s| a + s}
      when /\A(\d+)\Z/
        return Slot.new("#{$1}", Set{$1.to_i})
      when /\A(\d+)(\.\.|-)(\d+)\Z/
        return Slot.new("#{$1}-#{$3}", ($1.to_i .. $3.to_i).to_set)
      when /\A(\.\.|-)(\d+)\Z/
        return Slot.new("#{FIRST}-#{$2}", (FIRST .. $2.to_i).to_set)
      when /\A(\d+)(\.\.|-)\Z/
        return Slot.new("#{$1}-#{LAST}", ($1.to_i .. LAST).to_set)
      when /\A\[(\d+)->-([0-9a-f]+)\]\Z/  # MIGRATING
        # [3194->-5242463801bf74ea30caca8cd01b56b49fb9c06c]
        return Slot.new("#{$1}>", ($1.to_i .. $1.to_i).to_set, {$1.to_i => "M"})
      when /\A\[(\d+)-<-([0-9a-f]+)\]\Z/  # IMPORTING
        # [3194-<-5242463801bf74ea30caca8cd01b56b49fb9c06c]
        return Slot.new("#{$1}<", ($1.to_i .. $1.to_i).to_set, {$1.to_i => "I"})
      else
        raise "unsupported slot format: `#{str}`"
      end
    end

    delegate each, size, empty?, to: set
    property label, set, flags

    def initialize(@label : String, @set : Set(Int32), @flags : Hash(Int32, String) = Hash(Int32, String).new)
    end

    # special states: MIGRATING or IMPORTING
    def special?
      flags.any?
    end

    # same as name except special slots
    def signature
      @label.split(DELIMITER).select(/\A\d+($|-)/).sort_by(&.scan(/^(\d+)/).map(&.[0]).join.to_i).join(",")
    end

    def slots
      set.to_a
    end

    def +(other : Slot)
      name = [label, other.label].reject(&.empty?).join(",")
      Slot.new(name, set | other.set, flags.merge(other.flags))
    end

    def to_s(io : IO)
      io << label
    end

    def inspect(io : IO)
      io << label
    end
  end

  def self.slot(key : String) : Int32
    Slot.slot(key)
  end
end
