module GitGPG
  module Commands
    module Keys
      extend self

      def main(parser)
        puts "Command: #{File.basename(__FILE__, ".cr")}"
      end
    end
  end
end
