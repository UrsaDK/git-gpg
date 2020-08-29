module GitGPG
  module Commands
    module Uninstall
      extend self

      enum Target
        Local
        Global
      end

      class_property target = Target::Local

      def parse(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator()
        parser.on("-g", "--global", "Apply changes to all repositories") do
          target = Target::Global
        end
        parser.separator("\n#{parser_footer}")
      end

      def execute
        "==> GitGPG::Command::Uninstall.execute"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} uninstall [options]
        Remove #{GitGPG.name} integration
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        This command removes the following configuration sections:

          [filter "gpg"]
          [diff "gpg"]

        As an alternative to running this command, and assuming that you know
        what you're doing, you can remove the above sections manually.
        END_OF_FOOTER
      end
    end
  end
end
