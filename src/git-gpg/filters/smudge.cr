module GitGPG
  module Filters
    module Smudge
      extend self

      class_getter parser : OptionParser do
        Parser.update do |parser|
          parser.banner = "TEST: filter-smudge\n"
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
            #   "Invalid argument -- file",
            #   parser.to_s
            # )
          else
            file = Parser.args.first
          end
        end

        # TODO: decrypt file content
        output.join("\n")
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} smudge [options] <file>
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
