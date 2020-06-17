require "../patches/option_parser"

module GitGPG
  module OptionParser
    extend self

    class_getter args : Array(String) do
      ARGV unless ARGV.includes?("help")

      (ARGV - ["help"]).push("--help")
    end

    class_getter parser do
      ::OptionParser.new do |parser|
        parser.banner = "#{parser_banner}\n"

        parser.on("-q", "--quiet", "Reduces output to warnings and errors") do
          GitGPG.verbosity = Verbosity::Quiet
        end
        parser.on("-v", "--version", "Reports the version number") do
          raise Exceptions::OptionInfo.new(Attributes.version)
        end
        parser.on("-?", "--help", "Shows this help message") do
          raise Exceptions::OptionInfo.new(parser.to_s)
        end

        parser.separator("\nAvailable high level commands:\n")
        # parser.on("install", "Install Git GPG configuration") do
        #   Commands::Install.main(parser.command_args)
        # end
        # parser.on("keys", "List all GPG recipients that can decode a file") do
        #   Commands::Keys.main(parser.command_args)
        # end
        # parser.on("track", "Add paths to Git attributes file") do
        #   Commands::Track.main(parser.command_args)
        # end
        # parser.on("untrack", "Remove paths from Git attributes") do
        #   Commands::Untrack.main(parser.command_args)
        # end
        parser.on("version", "Report the version number") do
          raise Exceptions::OptionInfo.new(Attributes.version)
        end
        parser.on("help [command]", "Lookup help for the supplied command") do
          # This code is never reached -- `help` command is handled when
          # `args` parameter is initialised within at the top of this code.
        end

        parser.separator("\nSupported low level filters:\n")
        parser.on("clean", "Git filter used to encrypt file content") do
          Filters::Clean.main
        end
        parser.on("smudge", "Git filter used to decrypt file content") do
          Filters::Smudge.main
        end
        parser.on("textconv", "Git filter used to diff encrypted files") do
          Filters::Textconv.main
        end

        parser.separator("\n#{parser_footer}")
      end
    end

    def parse
      parser.invalid_option do |flag|
        raise Exceptions::OptionError.new(
          "Invalid option -- #{flag}",
          parser.to_s
        )
      end

      parser.parse(args)

      if command.nil?
        raise Exceptions::OptionError.new(
          "Missing argument -- command",
          parser.to_s
        )
      elsif !commands.includes?(command)
        raise Exceptions::OptionError.new(
          "Invalid command -- #{command}",
          parser.to_s
        )
      end
    end

    private def command
      args.find { |arg| arg.starts_with?(/[a-z]/) }
    end

    private def commands
      parser.flags.select(&.starts_with?(/\s*[a-z]/)).map do |command|
        command.chomp.split.first
      end
    end

    private def parser_banner
      <<-END_OF_BANNER
      Usage: #{Attributes.name} [options] <command>
      #{Attributes.description}
      END_OF_BANNER
    end

    private def parser_footer
      <<-END_OF_FOOTER
      Run a command followed by --help to see more information about it,
      for example:  #{Attributes.name} install --help
      END_OF_FOOTER
    end
  end
end
