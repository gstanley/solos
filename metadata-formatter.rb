module Rouge
  module Formatters
    class Metadata < Formatter
      tag 'metadata'

      def initialize(*)
      end

      def stream(tokens, &b)
        tokens.each do |tok, val|
          yield "#{tok.qualname} #{val}\n"
        end
      end
    end
  end
end
