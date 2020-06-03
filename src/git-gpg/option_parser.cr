require "option_parser"

module GitGPG
  class OptionParser < ::OptionParser
    record Command, command : String, block : String ->
    private getter commands : Array(Command)

    def self.parse(args = ARGV) : self
      parser = self.new
      yield parser
      parser.parse(args)
      parser
    end

    def self.option_args(args = ARGV)
      index = args.index { |a| ! a.starts_with?('-')}
      args[...index]
    end

    def self.command_args(args = ARGV)
      index = args.index { |a| ! a.starts_with?('-')}
      return [] of String if index.nil?

      args - args[..index]
    end

    def self.command(args = ARGV)
      args.find { |a| ! a.starts_with?('-')}
    end

    def initialize
      super
      @commands = [] of Command
    end

    def parse(args = ARGV)
      super(args)
      command = commands.find { |c| c.command == self.command }
      command.block.call "" unless command.nil?
    end

    def option_args(args = ARGV)
      self.class.option_args(args)
    end

    def command_args(args = ARGV)
      self.class.command_args(args)
    end

    def command(args = ARGV)
      self.class.command(args)
    end

    def dl(item, definition)
      append_flag(item, definition)
    end

    def cmd(command : String, description : String, &block : String ->)
      append_flag(command, description)
      @commands << Command.new(command, block)
    end

  end
end
