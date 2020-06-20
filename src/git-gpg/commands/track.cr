module GitGPG
  module Commands
    module Track
      extend self

      class_getter recipients = [] of String
      class_getter show_excluded_patterns = true

      def main
        OptionParser.parser.banner = "#{parser_banner}\n"
        OptionParser.parser.separator("")
        OptionParser.parser.on("-r EMAIL", "--recipients=EMAIL",
                               "Encrypt for email") do |recipient|
          recipients << recipient
        end
        OptionParser.parser.on("--no-excluded",
                               "Do not list excluded patterns") do
          @@show_excluded_patterns = false
        end
        OptionParser.parser.separator("\n#{parser_footer}")

        OptionParser.parser.unknown_args do |before_dash, after_dash|
          if before_dash.empty? && after_dash.empty?
            list_tracked
          else
            add_tracked(before_dash + after_dash)
          end
        end
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{Attributes.name} track [options] [<pattern> ...]
        View or add Git GPG paths to Git attributes.
        END_OF_BANNER
      end

      private def parser_footer
        <<-END_OF_FOOTER
        Start tracking the given patterns(s) through Git GPG. The pattern
        argument is written to .gitattributes. Files matching the pattern
        will be encrypted for the supplied recipients when they are next
        committed. Previously committed content will not be altered.

        The pattern can be either a glob pattern or a file path, eg:
          - #{Attributes.name} track
          - #{Attributes.name} track /my/secret.txt
          - #{Attributes.name} track "/config/*.yml"

        If no recipients are given than the recipient list will default to
        a single entry: the current user.

        If no pattern is provided, than list all currently-tracked paths.
        END_OF_FOOTER
      end

      private def list_tracked
        puts "--> Command::Track.list_tracked_path"
      end

      private def add_tracked(paths)
        puts "--> Command::Track.add_tracked_path"
        puts "  PATHS: #{paths}"
      end
    end
  end
end
