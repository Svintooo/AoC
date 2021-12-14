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
#pp polymer_pairs #DEBUG

element_count = {}
template.each{|element|
               element_count[element] ||= 0
               element_count[element] += 1
             }
#pp element_count #DEBUG

40.times do |step|
  #debug = false#step+1 == 1 #DEBUG
  tmp_polymer_pairs = {}

  polymer_pairs.each do |pair, count|
    insertion = rules[pair]
    element_count[insertion.first] ||= 0
    element_count[insertion.first] += count

    new_pair1 = pair[0..0] + insertion
    new_pair2 = insertion + pair[1..1]
    #puts if debug #DEBUG
    #puts "#{pair.join} => #{new_pair1.join} #{new_pair2.join}" if debug #DEBUG

    tmp_polymer_pairs[new_pair1] ||= 0
    tmp_polymer_pairs[new_pair2] ||= 0

    tmp_polymer_pairs[new_pair1] += count
    tmp_polymer_pairs[new_pair2] += count

    #pp polymer_pairs if debug #DEBUG
  end

  polymer_pairs = tmp_polymer_pairs
end

#p polymer #DEBUG

most_common_element  = element_count.max{|(char1,count1),(char2,count2)| count1 <=> count2 }.first
least_common_element = element_count.min{|(char1,count1),(char2,count2)| count1 <=> count2 }.first
#p [  most_common_element ,element_count[most_common_element ]  ] #DEBUG
#p [  least_common_element,element_count[least_common_element]  ] #DEBUG

## ANSWER
answer = element_count[most_common_element] - element_count[least_common_element]
puts answer
