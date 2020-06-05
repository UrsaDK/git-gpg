module GitGPG
  module Filters
    module Clean
      extend self

      def main(args)
        OptionParser.parse(args) do |parser|
          parser.banner = <<-END_OF_BANNER
          Usage: #{GitGPG.name} clean [options] <file>
          Git clean filter used to encrypt file content\n
          END_OF_BANNER

          parser.on("-?", "--help", "Shows this help message") do
            puts parser
            exit
          end

          parser.separator <<-END_OF_SEPARATOR
          \nThis filter accepts a single parameter which defines the path
          to the file the filter is working on.
          END_OF_SEPARATOR

          parser.invalid_option do |option|
            STDERR.puts "ERROR: #{option} is not a valid option"
            puts "\n#{parser}" unless GitGPG.verbosity == Verbosity::Quiet
            exit(1)
          end
        end

        puts "--> #{args}"
      end
    end
  end
end
