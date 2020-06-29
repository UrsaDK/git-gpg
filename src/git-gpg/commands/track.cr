module GitGPG
  module Commands
    module Track
      extend self

      class_getter parser do
        Parser.update do |parser|
          parser.banner = "#{parser_banner}\n"
          parser.separator("\n#{parser_footer}")
        end
      end

      def parse
        "--> GitGPG::Command::Track.parse"
      end

      private def parser_banner
        <<-END_OF_BANNER
        Usage: #{GitGPG.name} track [options] [<pattern> ...]
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
          - #{GitGPG.name} track
          - #{GitGPG.name} track /my/secret.txt
          - #{GitGPG.name} track "/config/*.yml"

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
        gitattributes = Git::GitGPG.new(".gitattributes")
        gitattributes.add(patterns, "filter=gpg", "diff=gpg",
                          "recipients=#{recipients.join(',')}")
      end
    end
  end
end
