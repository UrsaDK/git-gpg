module GitGPG
  module Filters
    module Textconv
      extend self

      class_getter parser : OptionParser do
        Parser.update do |parser|
          parser.banner = "TEST: filter-textconv\n"
        end
      end

      def main
        "==> GitGPG::Filters::Textconv.main"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} textconv [options] <file>
        Git textconv filter is used to produce a diff of the decrypted
        content of the encrypted file.
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
