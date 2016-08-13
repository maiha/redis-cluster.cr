# coding: utf-8

list = File.read_lines("#{__DIR__}/api.list").map(&.chomp)
impl = File.read_lines("#{__DIR__}/api.impl").map(&.chomp)
test = File.read_lines("#{__DIR__}/api.test").map(&.chomp)

group = nil
items = [] of String

count = ->(g : String) {
  list.count(&.=~ /^#{g}/)
}

flush = ->(g : String?) {
  return if g.nil?
  return if items.empty?

  # Ignore cluster methods because no needs to implement.
  if g == "cluster"
    items.clear
    return
  end

  max = items.map(&.size).max + 2
  all = count.call(g)
  ok  = items.count{|i| impl.includes?(i)}
  puts "### #{g.capitalize} (#{ok} / #{all})"
  puts ""
  puts "|%-#{max}s|impl|test|note|" % "Command"
  puts "|%s|----|----|----|" % ("-" * max)

  items.each do |key|
    name = "%-#{max}s" % "`#{key}`"
    implemented = impl.includes?(key) ? "  ✓ " : "    "
    tested      = test.includes?(key) ? "  ✓ " : "    "
    noted       = "    "
    puts "|#{name}|#{implemented}|#{tested}|#{noted}|"
  end
  puts ""
  items.clear
}

### Main

puts "# redis-cluster.cr "
puts "## Supported API"

list.each do |line|
  g, n = line.chomp.split(/\t/,2)
  flush.call(group) if group != g
  group = g
  items << n
end

flush.call(group)
