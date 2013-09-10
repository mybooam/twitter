require 'buftok'

module Twitter
  module Streaming
    class Response
      def initialize(&block)
        @block     = block
        @parser    = Http::Parser.new(self)
        @tokenizer = BufferedTokenizer.new("\r\n")
      end

      def <<(data)
        @parser << data
      end

      def on_headers_complete(headers)
        # TODO: handle response codes
        p(status_code: @parser.status_code, header: headers)
      end

      def on_body(data)
        p(data: data)
        @tokenizer.extract(data).each do |line|
          next if line.empty?
          @block.call(JSON.parse(line, :symbolize_names => true))
        end
      end

    end
  end
end