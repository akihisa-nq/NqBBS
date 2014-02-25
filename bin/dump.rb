#!/usr/bin/ruby

require "gdbm"
require "base64"

data_file = ARGV[0]
backup_file = ARGV[1]

File.open( backup_file, "w" ) do |file|
	GDBM.open( data_file, nil, GDBM::FAST ) do |db|
		db.each do |key, value|
			file << key << "\n"
			file << Base64.strict_encode64(value) << "\n"
		end
	end
end
