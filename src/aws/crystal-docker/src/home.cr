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
      context.response.content_type = "application/json"

      # Route base the http path
      if context.request.path == "/health"
        string = JSON.build do |json|
          json.object do
            json.field "status", "ok"
          end
        end
      else
        string = JSON.build do |json|
          json.object do
            json.field "method", "#{context.request.method}"
            json.field "path", "#{context.request.path}"
            if context.request.body.is_a?(IO)
              json.field "body", "#{context.request.body.as(IO).gets_to_end}"
            end
            json.field "query", "#{context.request.query}"
            json.field "query_params", "#{context.request.query_params}"
            json.field "headers", context.request.headers
          end
        end
      end
      context.response.print string
      
    end

    address = server.bind_tcp ENV["LISTEN_ADDR"].to_s, ENV["LISTEN_PORT"].to_i
    puts "Listening on http://#{ENV["LISTEN_ADDR"].to_s}:#{ENV["LISTEN_PORT"].to_s}"
    server.listen
rescue ex
    puts "Error: #{ex.message}"
    puts "#{ex.backtrace}"
    exit 1
end