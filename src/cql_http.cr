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
          if context.request.method == "GET"
            # q에 저장됨
            params = HTTP::Params.parse(context.request.query.as(String))
            context.response.print query_cql(params["q"])
          elsif context.request.method == "POST"
            # POST data
            if context.request.body
              query_string = context.request.body.as(IO).gets_to_end
              context.response.print query_cql(query_string)
            else
              puts "POST data is empty"
            end
          else
            puts "#{context.request.method} method is not supported"
          end
        else
          context.response.print "Hello world!"
        end
      end
      
      puts "Listening on http://#{host}:#{port}"
      server.listen
    end
    
    def self.query_cql(query_string)
      puts "query_cql >"
      Query.execute query_string
    end
  end
end


if ENV["ENV"]? != "test"
  CQL_HTTP::Server.start
end
