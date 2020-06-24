module GitGPG
  module Commands
    module Track
      extend self

      class_getter recipients = [] of String
      class_property? show_excluded : Bool = true

      def main(parser)
        parser.banner = "#{parser_banner}\n"
        parser.separator("")
        parser.on("-r EMAIL", "--recipients=EMAIL", "Encrypt for email") do |r|
          recipients << r
        end
        parser.on("--no-excluded", "Do not list excluded patterns") do
          show_excluded = false
        end
        parser.separator("\n#{parser_footer}")

        parser.unknown_args do |before_dash, after_dash|
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

        If no recipients are given than the recipient list will default the
        current user, as reported by: git config user.email

        If no pattern is provided, then list all currently-tracked paths.
        END_OF_FOOTER
      end

      private def list_tracked
        puts "--> Command::Track.list_tracked"
        "Command::Track.list_tracked_path"
      end

      private def add_tracked(patterns)
        gitattributes = Git::Attributes.new(".gitattributes")
        gitattributes.add(patterns, "filter=gpg", "diff=gpg",
                          "recipients=#{recipients.join(',')}")
      end
    end
  end
end
