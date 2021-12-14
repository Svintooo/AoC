#!/usr/bin/env ruby


## INPUT
template = nil
rules    = []

ARGF.each_line do |line|
  line = line.strip  # Remove newline character

  if line.match? /->/
    rules << line
  elsif line == ""
    next
  else
    template = line
  end
end
#p template #DEBUG
#p rules #DEBUG


## PARSING
template = template.chars
rules = rules.map{|rule|
               rule.split(/\s*->\s*/)
                   .map{|str| str.chars }
             }
             .to_h
#p template #DEBUG
#pp rules #DEBUG


## CALCULATE
#puts "Template: #{template.join}" #DEBUG

polymer_pairs = {}
0.upto(template.length-2).each do |i|
  pair = template[(i)..(i+1)]
  polymer_pairs[pair] ||= 0
  polymer_pairs[pair] += 1
end
pp polymer_pairs #DEBUG

#40.times do |step|
10.times do |step| #DEBUG
  debug = step+1 == 3 #DEBUG
  polymer_pairs.keys.each do |pair|
    insertion = rules[pair]
    new_pair1 = pair[0..0] + insertion
    new_pair2 = insertion + pair[1..1]
    puts if debug #DEBUG
    puts "#{pair.join} => #{new_pair1.join} #{new_pair2.join}" if debug #DEBUG

    polymer_pairs[pair] -= 1
    polymer_pairs.delete(pair) if polymer_pairs[pair] <= 0

    polymer_pairs[new_pair1] ||= 0
    polymer_pairs[new_pair2] ||= 0

    polymer_pairs[new_pair1] += 1
    polymer_pairs[new_pair2] += 1
    pp polymer_pairs if debug #DEBUG
  end

  puts #DEBUG
  puts "Step #{step+1}" #DEBUG
  pp polymer_pairs #DEBUG
  exit if debug #DEBUG
end

#p polymer #DEBUG
element_count = polymer_pairs.inject({}){|hashmap,(pair,count)|
                               hashmap[pair.first] ||= 0
                               hashmap[pair.last ] ||= 0

                               hashmap[pair.first] += count
                               hashmap[pair.last ] += count

                               hashmap
                             }

most_common_element  = element_count.max{|(char1,count1),(char2,count2)| count1 <=> count2 }.first
least_common_element = element_count.min{|(char1,count1),(char2,count2)| count1 <=> count2 }.first


## ANSWER
answer = element_count[most_common_element] - element_count[least_common_element]
puts answer
