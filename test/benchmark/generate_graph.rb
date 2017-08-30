require 'csv'
require 'gruff'

duration = Hash.new
memory = Hash.new
billed_duration = Hash.new

def generate_graph(gname, name,data)
  graph = Gruff::Line.new
  graph.title = gname
  graph.data(name, data)
  puts "#{gname}_#{name.gsub('/','_')}"
  graph.write("#{gname}_#{name.gsub('/','_')}.png")
end
CSV.foreach(ARGV[0], :headers => true) do |row|
    if duration[row[0]].nil?
       duration[row[0]] = Array.new
    end
    duration[row[0]].push(row[2].to_f)

    if billed_duration[row[0]].nil?
       billed_duration[row[0]] = Array.new
    end
    billed_duration[row[0]].push(row[3].to_f)
    if memory[row[0]].nil?
       memory[row[0]] = Array.new
    end
    memory[row[0]].push(row[5].to_f)

end
duration.each { |key,array|
   generate_graph("Duration", key, array)
}
billed_duration.each { |key,array|
   generate_graph("Billed Duration", key, array)
}
memory.each { |key,array|
   generate_graph("Memory", key, array)
}
