module GitGPG
  module Filters
    module Smudge
      extend self

      class_property file : String?

      class_getter input : String { STDIN.gets_to_end }
      class_getter output : Array(String) = [] of String

      def main(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator("\n#{parser_footer}")

        parser.unknown_args do
          if OptionParser.args.empty?
            raise Exceptions::OptionError.new(
              "Missing argument -- file",
              parser.to_s
            )
          elsif OptionParser.args.size > 1
            raise Exceptions::OptionError.new(
              "Invalid argument -- file",
              parser.to_s
            )
          else
            file = OptionParser.args.first
          end
        end

        # TODO: decrypt file content
        puts output.join("\n") unless output.empty?
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
