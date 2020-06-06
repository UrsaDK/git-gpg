require "../../spec_helper"

describe GitGPG::Filters::Clean do
  usage_header = "Usage: #{GitGPG.name} clean [options] <file>"

  context "help" do
    git_gpg_output("help clean sub-command", start_with(usage_header))
  end

  context "with missing file arg" do
    git_gpg_stderr("clean", eq("ERROR: Missing <file> argument\n"))
    git_gpg_stdout("clean", start_with("\n#{usage_header}"))
  end

  context "with too many file args" do
    git_gpg_stderr("clean one two", eq("ERROR: Too many <file> arguments\n"))
    git_gpg_stdout("clean one two", start_with("\n#{usage_header}"))
  end
end
