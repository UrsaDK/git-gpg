require "../patches/option_parser"

module GitGPG
  module Parser
    extend self

    class MissingCommand < ::Exception
      def initialize
        super("Missing command argument")
      end
    end

    class InvalidCommand < ::Exception
      def initialize(command)
        super("Invalid option: #{command}")
      end
    end

    class_getter args : Array(String) do
      return ARGV unless ARGV.includes?("help")

      (ARGV - ["help"]).push("--help")
    end

    private class_property option_parser do
      ::OptionParser.new do |parser|
        parser.banner = "#{parser_banner}\n"

        parser.on("-?", "--help", "Shows this help message") do
          GitGPG.execute { "#{option_parser}" }
        end

        parser.separator("\nAvailable high level commands:\n")
        parser.on("track", "Add paths to Git attributes file") do
          GitGPG.execute do
            puts "MONKEY"
            option_parser = Commands::Track.parser
            Commands::Track.parse
          end
        end
        parser.on("untrack", "Remove paths from Git attributes") do
          Commands::Untrack.parse
        end
      end
    end

    def update(&block) : OptionParser
      option_parser.tap { with self yield option_parser }
    end

    def parse
      option_parser.parse(args)

      # raise MissingCommand.new if command.nil?
      # raise InvalidCommand.new(command) unless commands.includes?(command)
    end

    def command
      args.find { |arg| arg.starts_with?(/[a-z]/) }
    end

    def to_s
      option_parser.to_s
    end

    private def commands
      option_parser.flags.select(&.starts_with?(/\s*[a-z]/)).map do |command|
        command.chomp.split.first
      end
    end

    private def parser_banner
      <<-END_OF_BANNER
      Usage: #{GitGPG.name} [options] <command>
      #{GitGPG.description}
      END_OF_BANNER
    end

    private def parser_footer
      <<-END_OF_FOOTER
      Run a command followed by --help to see more information about it,
      for example:  #{GitGPG.name} install --help
      END_OF_FOOTER
    end
  end
end
