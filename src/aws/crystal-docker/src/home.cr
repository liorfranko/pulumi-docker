require "http/server"
require "json"
# Set required vars, either to default or from ENV
ENV["LISTEN_ADDR"] ||= "0.0.0.0"
ENV["LISTEN_PORT"] ||= "80"

begin
    puts "Starting http server"
    
    server = HTTP::Server.new([
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new
    ]) do |context|
      context.response.content_type = "text/plain"

      # Route base the http path
      case context.request.path
      when "/health"
        context.response.print "ok"
      when "/json"
        context.response.content_type = "application/json"
        string = JSON.build do |json|
          json.object do
            json.field "method", "#{context.request.method}"
            json.field "path", "#{context.request.path}"
            json.field "body", "#{context.request.body}"
            json.field "query", "#{context.request.query}"
            json.field "query_params", "#{context.request.query_params}"
            json.field "headers", context.request.headers
          end
        end
        context.response.print string
      else
        context.response.print "Method: #{context.request.method}\n"
        context.response.print "Path: #{context.request.path}\n"
        context.response.print "Body: #{context.request.body}\n"
        context.response.print "Query: #{context.request.query}\n"
        context.response.print "Query Params: #{context.request.query_params}\n"
        context.response.print "Headers:\n"
        context.request.headers.each do |header|
          context.response.print "\t"
          context.response.print header[0]
          context.response.print ": "
          header[1].each do |h|
            context.response.print h
          end
          context.response.print "\n"
        end
        
        
        
        # Print the json link
        context.response.print "\n"
        if context.request.headers.has_key?("Host")
          if ENV["LISTEN_PORT"] == "80"
            context.response.print "To view it in a \"json\" format use: http://#{context.request.headers.get("Host")[0]}/json"
          else
            context.response.print "To view it in a \"json\" format use: http://#{context.request.headers.get("Host")[0]}:#{ENV["LISTEN_PORT"]}/json"
          end
        end
      end
    end

    address = server.bind_tcp ENV["LISTEN_ADDR"].to_s, ENV["LISTEN_PORT"].to_i
    puts "Listening on http://#{ENV["LISTEN_ADDR"].to_s}"
    server.listen
rescue ex
    puts "Error: #{ex.message}"
    puts "#{ex.backtrace}"
    exit 1
end