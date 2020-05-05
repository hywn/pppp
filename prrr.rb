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

defegex = /#def (\/.+?(?<!\\)\/[mi]*)\s(.+?)\s#fed\n?/m

keep_whitespace = true

input.scan defegex do |src, dest|

	output = output.sub defegex, ''

	regex = src.to_re
	
	while output.match? regex
	
		evaluated = dest
		
		groups = (output.match regex).to_a.each_with_index do |content, i|
			evaluated = evaluated.gsub("@#{i}", content)
		end
		
		if keep_whitespace
			padding = (output.match /(?<=\n)(.*?)#{Regexp.escape (output.match regex)[0]}/)[1]
				.gsub /[^\s]/, ' '
		
			evaluated = evaluated.gsub("\n", "\n#{padding}")
		end
		
		output = output.sub regex, evaluated
	
	end
	
end

puts output