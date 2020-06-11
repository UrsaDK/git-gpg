module GitGPG
  module Filters
    module Clean
      extend self

      def main(args)
        OptionParser.parse(args) do |parser|
          parser.banner = <<-END_OF_BANNER
          Usage: #{Attributes.name} clean [options] <file>
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
            raise GitGPG::Error.new("#{option} is not a valid option",
                                    parser.to_s)
          end
        end

        puts "--> #{args}"
      end
    end
  end
end
