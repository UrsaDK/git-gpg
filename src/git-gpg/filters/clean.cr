module GitGPG
  module Filters
    module Clean
      extend self

      class_getter file : String?

      def parse(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator("\n#{parser_footer}")
        parser.unknown_args do
          raise Parser::MissingArgs.new("file") if Parser.args.empty?

          @file = Parser.args.join(' ')
          raise Parser::InvalidArgs.new(file) if Parser.args.size > 1
        end
      end

      def execute
        "==> GitGPG::Filters::Clean.execute with #{file}"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} clean [options] <file>
        Git clean filter is used to encrypt file content just before
        the file is staged for a commit.
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        This filter accepts a single parameter which defines the path
        to the file the filter is working on. The content of the file
        should be provided to the filter on standard input.
        END_OF_FOOTER
      end
    end
  end
end
