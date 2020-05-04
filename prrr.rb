#!/usr/bin/env ruby

input = ARGF.read

class String
	# probably not a great idea
	# write something better later?
	def to_re()
		eval self
	end
end

output = input

input.scan /#define (\/.+\/[mi]*) (.+)/ do |src, dest|

	output = output.sub /#define (\/.+\/[mi]*) (.+)/, ''

	regex = src.to_re
	
	while output.match? regex
		
		evaluated = dest
		
		groups = (output.match regex).to_a.each_with_index do |content, i|
			evaluated = evaluated.gsub("@#{i}", content)
		end
		
		output = output.sub regex, evaluated
	end
end

puts output