require "time"

class Article
	def initialize
		@subject  = "No Subject"
		@author   = "Anonymous"
		@text     = "No Text"
		@file     = nil
		@file_url = nil
		@file_type = nil
		@date     = Time.now.getlocal.strftime("%Y年%m月%d日%H時%M分%S秒");
		@id = 0
	end

	def subject
		return @subject
	end
	def subject= subject
		@subject = subject unless subject == nil or subject == ""
	end

	def author 
		return @author
	end
	def author= author
		@author = author unless author == nil or author == ""
	end

	def text
		return @text
	end
	def text= text
		@text = text unless text == nil or text == ""
	end

	def file
		return @file
	end
	def file= tmpfile
		@file = tmpfile
	end

	def file_url
		return @file_url
	end
	def file_url= file_url
		@file_url = file_url
	end

	def file_type
		return @file_type
	end
	def file_type= file_type
		@file_type = file_type
	end

	def date
		return @date
	end
	def date= date
		@date = date unless date == nil or date == ""
	end

	def id
		return @id
	end
	def id= id
		@id = id unless id == nil
	end
end
