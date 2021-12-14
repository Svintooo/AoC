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
polymer = template.clone

#puts "Template: #{template.join}" #DEBUG

10.times do |step|
  i = 0

  while i <= polymer.length-2
    key = polymer[(i)..(i+1)]

    if rules.has_key?(key)
      insertion = rules[key]
      polymer = polymer[0..i] + insertion + polymer[(i+1)..-1]
      i += 1
    end

    i += 1
  end

  #puts "After step #{step+1}: #{polymer.join}" #DEBUG
end

#p polymer #DEBUG
element_count = polymer.inject({}){|hashmap, char|
                                    hashmap[char] ||= 0
                                    hashmap[char] += 1
                                    hashmap
                                  }

most_common_element  = element_count.max{|(char1,count1),(char2,count2)| count1 <=> count2 }.first
least_common_element = element_count.min{|(char1,count1),(char2,count2)| count1 <=> count2 }.first


## ANSWER
answer = element_count[most_common_element] - element_count[least_common_element]
puts answer
