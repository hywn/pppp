#!/usr/bin/env ruby

class String
	def to_re()
		# probably not a great idea
		# write something better later?
		eval self
	end
	def read_prrr()
		prrr File.read File.expand_path File.join ARGF.path, '..', self
	end
end

input = ARGF.read

DEFEGEX = /^#def (\/.+?(?<!\\)\/[mi]*)\s(.+?)\s#fed\n?/m
INCLEGEX = /^#include(d?) (.+)/
INCLUDED = /^#included (.+)\n?/

def prrr(input, defines=[], keep_whitespace=true)

	input = input.gsub "\r\n", "\n"

	output = input

	# process includes
	input.scan INCLEGEX do |silent, relpath|

		new_contents, new_defines = relpath.read_prrr

		defines.push *new_defines

		if silent.empty?
			output = output.sub INCLEGEX, new_contents
		else
			output = output.sub INCLUDED, ''
		end
	end

	# process defines
	input.scan DEFEGEX do |regex_string, replacement_string|

		defines.push [regex_string.to_re, replacement_string]

		output = output.sub DEFEGEX, ''
	end

	# run defines
	while defines.map { |p, r| output.match? p } .any?

		defines.each do |pattern, replacement|

			while output.match? pattern

				input_groups = (output.match pattern).to_a

				evaluated = replacement

				loop do

					match = evaluated.match /^(.*?)@(\d+?)/
					break if not match

					r = input_groups[match[2].to_i]

					r = r.gsub "\n", "\n#{match[1].gsub /[^\s]/, ' '}" if keep_whitespace

					evaluated = evaluated.sub /@#{match[2]}/, r
				end

				if keep_whitespace

					orig_text = Regexp.escape input_groups[0]

					padding = (output.match /^(.*?)#{orig_text}/)[1].gsub(/[^\s]/, ' ')

					evaluated = evaluated.gsub "\n", "\n#{padding}"
				end

				output = output.sub pattern, evaluated
			end
		end
	end

	[output, defines]
end

output, defines = prrr input

puts output