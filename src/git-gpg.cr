require "./patches/**"
require "./git-gpg/**"

module GitGPG
  extend self

  enum Verbosity
    Normal
    Quiet
  end

  class_property verbosity = Verbosity::Normal
  class_getter execute : Proc(String) = -> { "#{Parser}" }
  private class_setter execute

  def main
    Parser.parse
    puts execute.call
  rescue e : Exception
    abort "ERROR: #{e.message}"
  end

  def quiet?
    verbosity == Verbosity::Quiet
  end

  def execute(&block)
    execute = block
  end

  {{ run("#{__DIR__}/macros/shard_properties_to_methods") }}
end

{% unless @type.has_constant? "Spec" %}
  GitGPG.main
{% end %}
