#!/usr/bin/ruby

require "gdbm"
require "base64"

backup_file = ARGV[0]
data_file = ARGV[1]

GDBM.open( data_file, nil, GDBM::FAST | GDBM::WRCREAT ) do |db|
	File.open( backup_file, "r" ) do |file|
		is_key = true
		key = ""

		file.each_line do |line|
			if is_key
				key = line.strip
			else
				db[key] = Base64.decode64(line.strip)
			end

			is_key = !is_key
		end
	end
end
