module GitGPG
  module Commands
    module Version
      extend self

      def parse(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator("\n#{parser_footer}")
      end

      def execute
        GitGPG.version
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} version [options]
        Reports current #{GitGPG.name} version number
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        There is no difference between this command and `--version` option
        END_OF_FOOTER
      end
    end
  end
end
