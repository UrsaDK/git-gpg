require "../patches/option_parser"
require "./exception"

module GitGPG
  module Parser
    extend self

    macro execute(command)
      {{command}}.parse(parser)
      GitGPG.command { {{command}}.execute }
    end

    class InvalidOption < Exception
      def initialize(option)
        super(%Q(unknown option "#{option}" for "#{GitGPG.name}" command),
              Parser.to_s)
      end
    end

    class InvalidArgs < Exception
      def initialize(argument)
        super(%Q(unknown argument "#{argument}" for "#{GitGPG.name}"),
              Parser.to_s)
      end
    end

    class MissingArgs < Exception
      def initialize(argument)
        super(%Q(missing argument "#{argument}" for "#{GitGPG.name}" command),
              Parser.to_s)
      end
    end

    class_getter args : Array(String) do
      return ARGV unless ARGV.includes?("help")

      (ARGV - ["help"]).push("--help")
    end

    private class_getter option_parser do
      ::OptionParser.new do |parser|
        parser.banner = "#{parser_banner}\n"

        parser.on("-q", "--quiet", "Only show warnings & errors") do
          GitGPG.verbosity = Verbosity::Quiet
        end
        parser.on("-v", "--version", "Reports the version number") do
          GitGPG.command { Commands::Version.execute }
        end
        parser.on("-?", "--help", "Shows this help message") do
          help_text = parser.to_s
          GitGPG.command { "#{help_text}" }
        end

        parser.separator("\nAvailable commands:\n")
        parser.on("install", "Install #{GitGPG.name} integration") do
          execute(Commands::Install)
        end
        parser.on("recipients", "Manage a list recipients for a given file") do
          execute(Commands::Recipients)
        end
        parser.on("track", "Add paths to Git attributes file") do
          execute(Commands::Track)
        end
        parser.on("uninstall", "Remove #{GitGPG.name} integration") do
          execute(Commands::Uninstall)
        end
        parser.on("untrack", "Remove paths from Git attributes") do
          execute(Commands::Untrack)
        end
        parser.separator()
        parser.on("version", "Report #{GitGPG.name} version number") do
          execute(Commands::Version)
        end
        parser.on("help [command]", "Lookup help for the supplied command") do
          # this block allows us to include this command in user help message,
          # `help` is handled when `args` parameter is initialised (see above)
        end

        parser.separator("\nSupported filters:\n")
        parser.on("clean", "Git filter used to encrypt file content") do
          execute(Filters::Clean)
        end
        parser.on("smudge", "Git filter used to decrypt file content") do
          execute(Filters::Smudge)
        end
        parser.on("textconv", "Git filter used to diff encrypted files") do
          execute(Filters::Textconv)
        end

        parser.separator("\n#{parser_footer}")
        parser.invalid_option { |o| raise InvalidOption.new(o) }
        parser.unknown_args { parse_unknown_args }
      end
    end

    def parse
      option_parser.parse(args)
    end

    def to_s
      option_parser.to_s
    end

    private def command
      args.find { |arg| arg.starts_with?(/[a-z]/) }
    end

    private def commands
      option_parser.flags.select(&.starts_with?(/\s*[a-z]/)).map do |command|
        command.chomp.split.first
      end
    end

    private def parse_unknown_args
      unknown_args = args.reject(&.starts_with?('-'))
      raise InvalidArgs.new(unknown_args.first) unless unknown_args.empty?
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
