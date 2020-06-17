module GitGPG
  module Filters
    module Textconv
      extend self

      def main
        OptionParser.parser.banner = "#{parser_banner}\n"
        OptionParser.parser.separator("\n#{parser_footer}")
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{Attributes.name} textconv [options] <file>
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
