module GitGPG
  module Filters
    module Smudge
      extend self

      def main
        OptionParser.parser.banner = "#{parser_banner}\n"
        OptionParser.parser.separator("\n#{parser_footer}")
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{Attributes.name} smudge [options] <file>
        Git smudge filter is used to decrypt file content just before
        the file is checked out from the repository.
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
