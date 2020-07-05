module GitGPG
  module Commands
    module Install
      extend self

      class_getter parser : OptionParser do
        Parser.update do |parser|
          parser.banner = "TEST: command-install\n"
        end
      end

      def main
        "==> GitGPG::Command::Install.main"
      end
    end
  end
end
