require "./patches/**"
require "./git-gpg/**"

module GitGPG
  extend self

  enum Verbosity
    Normal
    Quiet
  end

  class_property verbosity = Verbosity::Normal
  class_property command : Proc(String) = -> { "#{GitGPG::Parser}" }

  def main
    Parser.parse
    puts command.call
  rescue e : Exception
    abort e.message
  end

  def quiet?
    verbosity == Verbosity::Quiet
  end

  {{ run("#{__DIR__}/macros/shard_properties") }}
end

{% unless @type.has_constant? "Spectator" %}
  GitGPG.main
{% end %}
