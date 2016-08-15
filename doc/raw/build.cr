tsv = File.read_lines("#{__DIR__}/tsv").map(&.chomp.split(/\t/,2))

puts   %(module Redis::Commands)
puts   %(  def raw(req : Array(RedisValue)))
puts   %(    cmd = req.first)
puts   %(    case cmd.downcase)
tsv.each do |a|
  puts %(    when "#{a[0]}")
  puts %(      #{a[1]}(req))
end
puts   %(    else)
puts   %(      raise "raw `\#{cmd}` is not supported yet")
puts   %(    end)
puts   %(  end)
puts   %(end)
