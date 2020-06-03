module GitGPG
  module Commands
    module Untrack
      extend self

      def main(args)
        puts "Command: #{File.basename(__FILE__, ".cr")}"
        puts "Args: #{args}"
      end
    end
  end
end
