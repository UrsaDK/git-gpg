module GitGPG
  module Filters
    module Clean
      extend self

      def main
        OptionParser.parser.banner = "#{parser_banner}\n"
        OptionParser.parser.separator("\n#{parser_footer}")
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{Attributes.name} clean [options] <file>
        Git clean filter used to encrypt file content
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
