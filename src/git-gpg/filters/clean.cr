module GitGPG
  module Filters
    module Clean
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
              "Invalid argument -- #{OptionParser.args}",
              parser.to_s
            )
          else
            file = OptionParser.args.first
          end
        end

        output << GPG.encrypt(file, input, recipients)
        puts output.join("\n") unless output.empty?
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{Attributes.name} clean [options] <file>
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
        Git.attribute(file, "recipients")
      end
    end
  end
end
