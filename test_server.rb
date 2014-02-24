# coding:utf-8

require "webrick"

RUBY_PATH = ENV["RUBY_PATH"]

http = WEBrick::HTTPServer.new(:BindAddress => "127.0.0.1", :Port => 8080, :CGIInterpreter => RUBY_PATH)
trap(:INT) { http.shutdown }

http.mount_proc("/") do |req, res|
	WEBrick::HTTPServlet::CGIHandler.new(http, "." + req.path_info).service(req, res)
end

http.start
