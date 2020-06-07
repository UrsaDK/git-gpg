require "yaml"
require "./spec_helper"

describe GitGPG do
  usage_header = "Usage: #{GitGPG.name} [options] <commands>"

  it_responds_to(GitGPG, main)
  it_responds_to(GitGPG, name)
  it_responds_to(GitGPG, verbosity)
  it_responds_to(GitGPG, version)

  describe ".name" do
    it "returns: git gpg" do
      GitGPG.name.should eq("git gpg")
    end
  end

  describe ".verbosity" do
    it "defaults to NORMAL" do
      GitGPG.verbosity.should eq(GitGPG::Verbosity::Normal)
    end
  end

  describe "version" do
    shard_version = begin
      shard_yml = "#{__DIR__}/../shard.yml"
      YAML.parse(File.read(shard_yml))["version"]
    end

    git_gpg_output("-v", eq("#{shard_version}\n"))
    git_gpg_output("--version", eq("#{shard_version}\n"))
    git_gpg_output("version", eq("#{shard_version}\n"))

    it "is returned by .version" do
      GitGPG.version.should eq(shard_version)
    end
  end

  describe "help" do
    git_gpg_output("-?", start_with(usage_header))
    git_gpg_output("--help", start_with(usage_header))
    git_gpg_output("help", start_with(usage_header))
    git_gpg_output("help --invalid-option", start_with(usage_header))
  end

  context "with invalid option" do
    git_gpg_stderr("--invalid-option",
                   eq("ERROR: --invalid-option is not a valid option\n"))
    git_gpg_stdout("--invalid-option",
                   start_with("\n#{usage_header}"))
  end

  context "with invalid command" do
    git_gpg_stderr("invalid-command",
                   eq("ERROR: invalid-command is not a valid command\n"))
    git_gpg_stdout("invalid-command",
                   start_with("\n#{usage_header}"))
    git_gpg_stderr("help invalid-command",
                   eq("ERROR: invalid-command is not a valid command\n"))
    git_gpg_stdout("help invalid-command",
                   start_with("\n#{usage_header}"))
  end

  context "with missing command" do
    git_gpg_stderr("", eq("ERROR: Missing #{GitGPG.name} command\n"))
    git_gpg_stdout("", start_with("\n#{usage_header}"))
  end
end
