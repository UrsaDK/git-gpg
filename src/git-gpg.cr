require "./git-gpg/option_parser"
require "./git-gpg/exceptions/*"

module GitGPG
  extend self

  enum Verbosity
    Normal
    Quiet
  end

  class_property verbosity = Verbosity::Normal

  def main(args = ARGV)
    OptionParser.parse(args)
  rescue e : Exceptions::OptionInfo
    puts e.message
    exit
  rescue e : Exceptions::OptionError
    STDERR.puts e.message
    puts "\n#{e.explanation}" unless verbosity_quiet? || e.explanation.empty?
    exit(1)
  end

  private def verbosity_quiet?
    verbosity == Verbosity::Quiet
  end
end

{% unless @type.has_constant? "Spec" %}
  GitGPG.main
{% end %}
