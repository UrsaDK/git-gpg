require "../patches/option_parser"
require "./exception"

module GitGPG
  module Parser
    extend self

    class MissingCommand < Exception
      def initialize
        super(%Q(missing command for "#{GitGPG.name}"),
              Parser.to_s)
      end
    end

    class InvalidCommand < Exception
      def initialize(command)
        super(%Q(unknown command "#{command}" for "#{GitGPG.name}"),
              Parser.to_s)
      end
    end

    class InvalidOption < Exception
      def initialize(option)
        super(%Q(unknown option "#{option}" for "#{GitGPG.name}" command),
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
          GitGPG.defer { GitGPG.version }
        end
        parser.on("-?", "--help", "Shows this help message") do
          help_text = parser.to_s
          GitGPG.defer { "#{help_text}" }
        end

        parser.separator("\nAvailable high level commands:\n")
        parser.on("install", "Install Git GPG configuration") do
          parser = Commands::Install.parser
          GitGPG.defer { Commands::Install.main }
        end
        parser.on("recipients",
                  "List all GPG recipients that can decode a file") do
          parser = Commands::Recipients.parser
          GitGPG.defer { Commands::Recipients.main }
        end
        parser.on("track", "Add paths to Git attributes file") do
          parser = Commands::Track.parser
          GitGPG.defer { Commands::Track.main }
        end
        parser.on("untrack", "Remove paths from Git attributes") do
          parser = Commands::Untrack.parser
          GitGPG.defer { Commands::Untrack.main }
        end
        parser.on("version", "Report the version number") do
          GitGPG.defer { GitGPG.version }
        end
        parser.on("help [command]", "Lookup help for the supplied command") do
          # `help` is handled when `args` parameter is initialised (see above),
          # but we do want to include this command as part of user help message
        end

        parser.separator("\nSupported low level filters:\n")
        parser.on("clean", "Git filter used to encrypt file content") do
          parser = Filters::Clean.parser
          GitGPG.defer { Filters::Clean.main }
        end
        parser.on("smudge", "Git filter used to decrypt file content") do
          parser = Filters::Smudge.parser
          GitGPG.defer { Filters::Smudge.main }
        end
        parser.on("textconv", "Git filter used to diff encrypted files") do
          parser = Filters::Textconv.parser
          GitGPG.defer { Filters::Textconv.main }
        end

        parser.separator("\n#{parser_footer}")
        parser.invalid_option { |o| raise InvalidOption.new(o) }
      end
    end

    def update(&block) : OptionParser
      option_parser.tap { yield option_parser }
    end

    def parse
      raise MissingCommand.new if command.nil?
      raise InvalidCommand.new(command) unless commands.includes?(command)
    ensure
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
