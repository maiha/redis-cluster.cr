impl = File.read_lines("#{__DIR__}/impl").map(&.chomp)

puts <<-EOF
module Redis::Cluster::Commands
  SET = Set.new(%w(
    #{impl.join("\n    ")}
  ))

  def self.[]?(key)
    SET.includes?(key.to_s.downcase)
  end
end
EOF
