module GitGPG
  module Commands
    module Install
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
        "==> GitGPG::Command::Install.execute"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} install [options]
        Install #{GitGPG.name} integration
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        This command adds the following configuration settings:

          [filter "gpg"]
            required = true
            clean = #{GitGPG.name} clean -- %f
            smudge = #{GitGPG.name} smudge -- %f

          [diff "gpg"]
            textconv = #{GitGPG.name} textconv

        As an alternative to running this command, and assuming that you know
        what you're doing, you can add the above changes manually.
        END_OF_FOOTER
      end
    end
  end
end
