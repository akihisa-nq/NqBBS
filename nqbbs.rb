#!/usr/bin/ruby
# coding:euc-jp

require "cgi"
require "kconv"
require "erb"

$: << File.dirname(__FILE__)

require "lib/article"
require "lib/storage"

storage = Storage.new("data.gdb")
CGI.accept_charset = "euc-jp"

cgi = CGI.new
new_article = Article.new
mode = "view"

del_id = -1

if cgi.multipart?
	new_article.subject = Kconv::toeuc cgi['subject'].read if cgi.include? "subject"
	new_article.author  = Kconv::toeuc cgi['author'].read if cgi.include? "author"
	new_article.text  = Kconv::toeuc cgi['text'].read if cgi.include? "text"
	new_article.file = cgi['file'] if cgi.include? "file" and not cgi['file'].size == 0

	mode = cgi['mode'].read if cgi.include? "mode"

	del_id = cgi['del_id'].read.to_i if cgi.include? "del_id"
else
	mode = cgi.params['mode'][0] if cgi.include? "mode"

	storage.start = cgi.params['start'][0].to_i if cgi.include? "start"
	storage.num = cgi.params['num'][0].to_i if cgi.include? "num"

	id = cgi.params['id'][0] if cgi.include? 'id'

	del_id = cgi.params['del_id'][0].to_i if cgi.include? 'del_id'
end

if mode == "add"
	storage.add_article new_article

	print "Location: ./nqbbs.rb\n\n"
end

if mode == "get"
	print "Content-type: image/png\n\n"
	print storage.get_image(id)
end

if mode == "view"
	print "Content-type: text/html\n\n"

	File.open("./template.rhtml", "r:euc-jp" ) do |file|
		ERB.new(file.read).run
	end
end

if mode == "del" and cgi.include? "del_id"
	storage.del_article del_id
	
	print "Location: ./nqbbs.rb"
	
	print "?start=" + storage.start.to_s if cgi.include? "start"
	
	print "\n\n"
end
