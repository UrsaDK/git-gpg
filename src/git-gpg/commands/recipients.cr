module GitGPG
  module Commands
    module Recipients
      extend self

      class_getter parser : OptionParser do
        Parser.update do |parser|
          parser.banner = "TEST: command-recipients\n"
        end
      end

      def main
        "==> GitGPG::Command::Recipients.main"
      end
    end
  end
end
