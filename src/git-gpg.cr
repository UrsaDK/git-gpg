require "./git-gpg/**"

module GitGPG
  extend self

  def main(args = ARGV)
    OptionParser.parse(OptionParser.option_args(args)) do |parser|
      parser.banner = <<-END_OF_BANNER
      Usage: #{shard[:name]} [options] <commands>
      #{shard[:description]}\n
      END_OF_BANNER

      parser_options(parser)
      parser_errors(parser)

      parser.separator("\nAvailable high level commands:\n")
      parser_commands(parser)

      parser.separator("\nSupported low level filters:\n")
      parser_filters(parser)

      parser.separator <<-END_OF_SEPARATOR
      \nRun a command followed by --help to see command specific information,
      for example:  #{shard[:name]} install --help
      END_OF_SEPARATOR
    end
  end

  private def parser_options(parser)
    parser.on("-v", "--version", "Reports the version number.") do
      puts shard[:version]
      exit
    end
    parser.on("-?", "--help", "Shows this help message") do
      puts parser
      exit
    end
  end

  private def parser_commands(parser)
    parser.cmd("install", "Install Git GPG configuration") do
      Commands::Install.main(parser.command_args)
    end
    parser.cmd("keys", "List all GPG recipients that can decode a file") do
      Commands::Keys.main(parser.command_args)
    end
    parser.cmd("track", "Add paths to Git attributes file") do
      Commands::Track.main(parser.command_args)
    end
    parser.cmd("untrack", "Remove paths from Git attributes") do
      Commands::Untrack.main(parser.command_args)
    end
    parser.cmd("version", "Report the version number.") do
      puts shard[:version]
      exit
    end
    parser.cmd("help COMMAND", "Lookup help for a command") do
      puts parser
      exit
    end
  end

  private def parser_filters(parser)
    parser.cmd("clean", "Git filter used to encrypt file content") do
      Filters::Clean.main(parser.command_args)
    end
    parser.cmd("smudge", "Git filter used to decrypt file content") do
      Filters::Smudge.main(parser.command_args)
    end
    parser.cmd("textconv", "Git filter used to diff encrypted files") do
      Filters::Textconv.main(parser.command_args)
    end
  end

  private def parser_errors(parser)
    parser.missing_option do |option|
      STDERR.puts "ERROR: #{option} is missing an argument"
      puts "\n#{parser}"
      exit(1)
    end
    parser.invalid_option do |option|
      STDERR.puts "ERROR: #{option} is not a valid option"
      puts "\n#{parser}"
      exit(1)
    end
  end

  private def shard
    {{ run("#{__DIR__}/macros/read_shard_yml") }}
  end
end

GitGPG.main
