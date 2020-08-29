module GitGPG
  module Commands
    module Untrack
      extend self

      def parse(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator("\n#{parser_footer}")
        parser.unknown_args do
          raise Parser::MissingArgs.new("pattern") if Parser.args.empty?
        end
      end

      def execute
        "==> GitGPG::Command::Untrack.execute with #{Parser.args}"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} untrack [options] <pattern>
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
