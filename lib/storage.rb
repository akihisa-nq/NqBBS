require "gdbm"
require "lib/article"

class Storage
	def initialize data_file
		@data_file = data_file

		@start = self.load_last_number
		@num = 10
		@prevous_id = self.load_last_number - 20
	end

	def start
		return @start
	end
	def start= start
		last = self.load_last_number
		if @start > last
			@start = last
		else
			@start = start 
		end
	end

	def num
		return @num
	end
	def num= num
		@num = num 
	end

	def prevous_id
		return @prevous_id
	end
	def prevous_id= prevous_id
		@prevous_id = prevous_id
	end

	def load_last_number
		GDBM.open @data_file, nil, GDBM::FAST do |db|
			return db.include?( "last") ? db["last"].to_i : 0
		end
	end

	def load_articles 
		last = self.load_last_number
		i = @start > last ? last : @start
		j = 0

		GDBM.open @data_file, nil, GDBM::FAST do |db|
			while i >= 1 and j < @num
				article = Article.new

				key = "id" + i.to_s + "author"
				article.author = db[key] if db.include? key

				key = "id" + i.to_s + "subject"
				article.subject = db[key] if db.include? key

				key = "id" + i.to_s + "date"
				article.date = db[key] if db.include? key

				key = "id" + i.to_s + "file"
				article.file_url = db[key] if db.include? key

				key = "id" + i.to_s + "file_url"
				article.file_url = db[key] if db.include? key

				key = "id" + i.to_s + "file_type"
				article.file_type = db[key] if db.include? key

				article.id = i
				
				key = "id" + i.to_s + "text"
				if db.include? key
					article.text = db[key] 
					yield article
					j += 1
				end

				i -= 1
			end

			@prevous_id = i
		end
	end

	def add_article article
		id = self.load_last_number + 1

		GDBM.open @data_file, nil, GDBM::FAST do |db|
			db["last"] = id.to_s
			db["id" + id.to_s + "author"] = article.author
			db["id" + id.to_s + "subject"] = article.subject
			db["id" + id.to_s + "date"] = article.date
			if not article.file == nil
				db["id" + id.to_s + "file"] = article.file.read
				db["id" + id.to_s + "file_url"] = "nqbbs.rb?mode=get&id=" + id.to_s
				#db["id" + id.to_s + "file_type"] = article.file_type
			end
			db["id" + id.to_s + "text"]   = article.text 
			db.sync
		end
	end

	def del_article id
		if id >= 1 and id <= self.load_last_number
			GDBM.open @data_file, nil, GDBM::FAST do |db|
				db.delete "id" + id.to_s + "author"
				db.delete "id" + id.to_s + "subject"
				db.delete "id" + id.to_s + "date"
				db.delete "id" + id.to_s + "file"
				db.delete "id" + id.to_s + "file_url"
				db.delete "id" + id.to_s + "text"
				db.sync
			end
		end
	end

	def get_image id
		GDBM.open @data_file, nil, GDBM::FAST do |db|
			return db["id" + id + "file"] if db.include? "id" + id + "file"
		end
	end
end
