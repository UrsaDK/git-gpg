module GitGPG
  module Commands
    module Untrack
      extend self

      def main
        OptionParser.parser.banner = "#{parser_banner}\n"
        OptionParser.parser.separator("\n#{parser_footer}")

        OptionParser.parser.unknown_args do
          if OptionParser.args.empty?
            raise Exceptions::OptionError.new(
              "Missing argument -- pattern",
              OptionParser.parser.to_s
            )
          end
        end

        # TODO
        puts "--> Command::Untrack.main"
        puts "  ARGS: #{OptionParser.args}"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{Attributes.name} untrack [options] <pattern>
        Remove Git GPG paths from Git attributes.
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        Stop tracking the given patterns(s) through Git GPG. The matching
        pattern is removed from .gitattributes. Files matching the pattern
        will be store UNENCRYPTED the next time they are committed. Content
        already committed to the repository, will not be altered.

        The pattern can be either a glob pattern or a file path, eg:
        END_OF_FOOTER
      end
    end
  end
end
