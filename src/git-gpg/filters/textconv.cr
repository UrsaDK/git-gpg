module GitGPG
  module Filters
    module Textconv
      extend self

      class_getter file : String?

      def parse(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator("\n#{parser_footer}")
        parser.unknown_args do
          raise Parser::MissingArgs.new("file") if Parser.args.empty?

          @@file = Parser.args.join(' ')
          raise Parser::InvalidArgs.new(file) if Parser.args.size > 1
        end
      end

      def execute
        "==> GitGPG::Filters::Textconv.execute with #{file}"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} textconv [options] <file>
        Git textconv filter is used to produce a diff of the decrypted
        content for the encrypted file.
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        This filter accepts a single parameter which defines the path
        to the file the filter is working on.
        END_OF_FOOTER
      end
    end
  end
end
