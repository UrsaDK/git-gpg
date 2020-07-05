module GitGPG
  module Filters
    module Clean
      extend self

      class_getter parser : OptionParser do
        Parser.update do |parser|
          parser.banner = "TEST: filter-clean\n"
        end
      end

      class_property file : String?

      class_getter input : String { STDIN.gets_to_end }
      class_getter output : Array(String) = [] of String

      def main
        parser.banner = "#{parser_banner}\n"
        parser.separator("\n#{parser_footer}")

        parser.unknown_args do
          if Parser.args.empty?
            # raise Exceptions::OptionError.new(
            #   "Missing argument -- file",
            #   parser.to_s
            # )
          elsif Parser.args.size > 1
            # raise Exceptions::OptionError.new(
            #   "Invalid argument -- #{Parser.args}",
            #   parser.to_s
            # )
          else
            file = Parser.args.first
          end
        end

        output << GPG.encrypt(file, input, recipients)
        output.join("\n")
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

      private def recipients
        # TODO: Read recipients from .gitattributes file
      end
    end
  end
end
