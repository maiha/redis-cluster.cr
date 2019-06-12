record Redis::Cluster::NodeInfo,
  sha1   : String,
  addr   : Addr,
  flags  : String,
  master : String,
  sent   : Int64,
  recv   : Int64,
  epoch  : Int64,
  status : String,
  slot   : Slot do

  def_equals_and_hash sha1
  delegate host, port, cport, to: addr
  
  val is_master = !! flags["master"]?
  val is_slave  = !! flags["slave"]?
  val is_fail   = !! flags["fail"]?

  val is_connected    = status.split(",").includes?("connected")
  val is_disconnected = !! status["disconnected"]?

  def sha1_6
    "#{sha1}??????"[0..5]
  end

  def signature
    "#{sha1}:#{slot.signature}"
  end

  def role
    flags.sub(/myself,/, "")
  end
  
  def slot?
    !slot.empty?
  end

  def serving?
    slot?
  end

  def standalone?
    !serving? && !is_slave
  end

  def has_master?
    ! master.empty?
  end

  def first_slot : Int32
    slot.slots.first {
      raise "[BUG] #{addr} has no slot_range"
    }
  end
  
  def to_s(io : IO)
    io << "[%s] (%s) %6s" % [sha1_6, addr, role]
  end
end
