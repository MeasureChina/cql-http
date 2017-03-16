require "json"

module CQL_HTTP
  class Query
    def self.execute(q)
      cql_sh = ENV["cql_sh"]
      output = IO::Memory.new
      
      puts "  query => #{q}"
      puts "  cmd => #{cql_sh} -e \"#{q}\""
      
      c = Process.run "#{cql_sh} -e \"#{q}\"", shell: true, output: output
      puts "  process exit code => #{c.exit_code}"
      puts "  output size => #{output.size}"
      
      if q.match /^select\s/
        parse_cql_select output.to_s
      else
        output.to_s
      end
    end
    
    def self.parse_cql_select(o)
      lines = o.split /\r?\n/
      
      columns = [] of String
      rows = [] of Array(String)
      schema = [] of Int32
      
      # id | page              | count
      lines[1].split(" | ").each do |name|
        schema.push name.size
        columns.push name.strip
      end
      
      # data rows가 시작되는 시점
      i = 3
      
      #  1 |            /page1 |   100
      begin
        
        # iterate all of lines
        while d = lines[i]?
          # check whether data row
          if d.match /\|/
            n = 0
            row = [] of String
            
            schema.each do |num|
              s = d[n..n + num - 1]
              row.push s.strip
              n = n + num + 3
            end
            
            rows.push row
          end
          
          # next line
          i += 1
        end
        
      rescue ex: IndexError
        puts ex
        puts "> ignore IndexError"
      end
      
      puts "  rows count => #{rows.size}"
      
      { count: rows.size, columns: columns, rows: rows }
    end
  end
end
