require "option_parser"

module GitGPG
  class OptionParser < ::OptionParser
    class InvalidCommand < ::OptionParser::Exception
      def initialize(command)
        super("Invalid command: #{command}")
      end
    end

    class MissingCommand < ::OptionParser::Exception
      def initialize(command)
        super("Missing command: #{command}")
      end
    end

    record Command, command : String, block : String ->
    private getter commands : Array(Command)

    getter command : String
    getter option_args : Array(String)
    getter command_args : Array(String)

    def self.parse(args = ARGV) : self
      parser = self.new
      yield parser
      parser.parse(args)
      parser
    end

    def self.option_args(args = ARGV) : Array(String)
      index = args.index { |a| ! a.starts_with?('-')}
      args[..index]
    end

    def self.command_args(args = ARGV) : Array(String)
      index = args.index { |a| ! a.starts_with?('-')}
      return [] of String if index.nil?

      args - args[..index]
    end

    def self.command(args = ARGV) : String
      args.find { |a| ! a.starts_with?('-')}.to_s
    end

    def initialize
      super
      @commands = [] of Command

      @option_args = [] of String
      @command_args = [] of String
      @command = ""

      @invalid_command = ->(command : String) do
        raise InvalidCommand.new(command)
      end
      @missing_command = ->(command : String) do
        raise MissingCommand.new(command) unless commands.empty?
      end
    end

    def parse(args = ARGV)
      @option_args = self.class.option_args(args)
      @command_args = self.class.command_args(args)
      @command = self.class.command(args)

      super(option_args)

      exec = commands.find { |c| c.command == command }
      if exec.nil? && command.empty?
        @missing_command.call("")
      elsif exec.nil?
        @invalid_command.call(command)
      else
        exec.block.call("")
      end
    end

    def cmd(command : String, description : String, &block : String ->)
      append_flag(command, description)
      commands << Command.new(command.split.first, block)
    end

    def invalid_command(&@invalid_command : String ->)
    end

    def missing_command(&@missing_command : String ->)
    end
  end
end
