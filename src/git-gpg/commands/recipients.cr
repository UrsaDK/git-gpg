module GitGPG
  module Commands
    module Recipients
      extend self

      @[Flags]
      enum List
        Recipients
        Files
      end

      class_getter recipients = [] of String
      class_property list_patterns = List::All

      def parse(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator()
        parser.on("-a EMAIL", "--add=EMAIL", "Add a new recipient") do |_|
          # TODO
        end
        parser.on("-d EMAIL", "--del=EMAIL", "Delete a recipient") do |_|
          # TODO
        end
        parser.on("--no-files", "Do not show a list of accessible files") do
          list_patterns = List::Recipients
        end
        parser.separator("\n#{parser_footer}")
        parser.unknown_args do
          # raise Parser::InvalidArgument if arg is not a file
        end
      end

      def execute
        "==> GitGPG::Command::Recipients.execute with #{Parser.args}"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} recipients [options] [<file> ...]
        List all GPG recipients that can decode file's content.
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        If --add or --del option is given then output will list all recipients
        that can decode supplied file's content. The output will also include
        a list of all other files current group of recipients has access to.

        If either --add or --del option is supplied then the resulting list of
        recipients will be created after the requested change is applied.
        END_OF_FOOTER
      end
    end
  end
end
