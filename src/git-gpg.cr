require "./patches/**"
require "./git-gpg/**"

module GitGPG
  extend self

  enum Verbosity
    Normal
    Quiet
  end

  class_property verbosity = Verbosity::Normal

  def main
    OptionParser.parse
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
