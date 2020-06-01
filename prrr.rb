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

			output.gsub!(pattern) {

				evaluated = replacement

				input_groups = output.match(pattern).to_a

				pre = $`.lines[-1].chomp.gsub /[^\s]/, ' '
				evaluated.gsub! "\n", "\n#{pre}" if keep_whitespace

				evaluated.gsub(/@(\d+?)/) {

					r = input_groups[$1.to_i]

					pre = $`.lines[-1].chomp.gsub /[^\s]/, ' '
					r.gsub! "\n", "\n#{pre}" if keep_whitespace

					r

				}
			}
		end
	end

	[output, defines]
end

output, defines = prrr input

print output