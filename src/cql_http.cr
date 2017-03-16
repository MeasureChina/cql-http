require "http/server"
require "./cql_http/**"

module CQL_HTTP
  class Server
    def self.start
      host = ENV["cql_host"]
      port = ENV["cql_port"].to_i
      
      server = HTTP::Server.new(host, port) do |context|
        context.response.content_type = "text/plain"
        
        if context.request.path == "/query"
          context.response.print query_cql(context.request.query)
        else
          context.response.print "Hello world!"
        end
      end
      
      puts "Listening on http://#{host}:#{port}"
      server.listen
    end
    
    def self.query_cql(query_string)
      puts "query_cql >"
      params = HTTP::Params.parse query_string.as(String)
      
      Query.execute params["q"]
    end
  end
end


if ENV["ENV"]? != "test"
  CQL_HTTP::Server.start
end
