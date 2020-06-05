require "yaml"
require "./spec_helper"

describe GitGPG do
  git_gpg = "#{__DIR__}/../bin/git-gpg"

  it "responds to .main" do
    GitGPG.responds_to?(:main).should be_true
  end
  it "responds to .version" do
    GitGPG.responds_to?(:version).should be_true
  end
  it "responds to .verbosity" do
    GitGPG.responds_to?(:verbosity).should be_true
  end

  context "version" do
    shard = begin
      shard_yml = "#{__DIR__}/../shard.yml"
      YAML.parse(File.read(shard_yml))
    end

    it "is returned by .version" do
      GitGPG.version.should eq(shard["version"])
    end
    it "is shown by -v" do
      `#{git_gpg} -v`.strip.should eq(shard["version"])
      $?.success?.should be_true
    end
    it "is shown by --version" do
      `#{git_gpg} --version`.strip.should eq(shard["version"])
      $?.success?.should be_true
    end
    it "is shown by version command" do
      `#{git_gpg} version`.strip.should eq(shard["version"])
      $?.success?.should be_true
    end
  end

  context "help" do
    it "is shown by -?" do
      `#{git_gpg} -?`.should start_with("Usage: git-gpg ")
      $?.success?.should be_true
    end
    it "is shown by --help" do
      `#{git_gpg} --help`.should start_with("Usage: git-gpg ")
      $?.success?.should be_true
    end
    it "is shown by help command" do
      `#{git_gpg} help`.should start_with("Usage: git-gpg ")
      $?.success?.should be_true
    end
    it "is shown by help command with any argument" do
      `#{git_gpg} help --invalid-option`.should start_with("Usage: git-gpg ")
      $?.success?.should be_true
    end
  end

  context ".verbosity" do
    it "defaults to NORMAL" do
      GitGPG.verbosity.should eq(GitGPG::Verbosity::Normal)
    end
  end

  context "with invalid option" do
    args = "--invalid-option"
    it "shows error message" do
      `#{git_gpg} #{args} 2>&1 >/dev/null`.should start_with(
        "ERROR: --invalid-option is not a valid option"
      )
      $?.success?.should be_false
    end
    it "shows help message" do
      `#{git_gpg} #{args} 2>/dev/null`.should start_with("\nUsage: git-gpg ")
      $?.success?.should be_false
    end
  end

  context "with invalid option in quiet mode" do
    args = "--invalid-option --quiet"
    it "shows error message" do
      `#{git_gpg} #{args} 2>&1 >/dev/null`.should start_with(
        "ERROR: --invalid-option is not a valid option"
      )
      $?.success?.should be_false
    end
    it "does not show help" do
      `#{git_gpg} #{args} 2>/dev/null`.should be_empty
      $?.success?.should be_false
    end
  end

  context "with invalid command" do
    args = "invalid-command"
    it "shows error message" do
      `#{git_gpg} #{args} 2>&1 >/dev/null`.should start_with(
        "ERROR: invalid-command is not a valid command"
      )
      $?.success?.should be_false
    end
    it "shows help message" do
      `#{git_gpg} #{args} 2>/dev/null`.should start_with("\nUsage: git-gpg ")
      $?.success?.should be_false
    end
  end

  context "with invalid command in quiet mode" do
    args = "--quiet invalid-command"
    it "shows error message" do
      `#{git_gpg} #{args} 2>&1 >/dev/null`.should start_with(
        "ERROR: invalid-command is not a valid command"
      )
      $?.success?.should be_false
    end
    it "does not show help" do
      `#{git_gpg} #{args} 2>/dev/null`.should be_empty
      $?.success?.should be_false
    end
  end

  context "with missing command" do
    it "shows error message" do
      `#{git_gpg} 2>&1 >/dev/null`.should start_with(
        "ERROR: missing git-gpg command"
      )
      $?.success?.should be_false
    end
    it "shows help message" do
      `#{git_gpg} 2>/dev/null`.should start_with("\nUsage: git-gpg ")
      $?.success?.should be_false
    end
  end

  context "with missing command in quiet mode" do
    args = "--quiet"
    it "shows error message" do
      `#{git_gpg} 2>&1 >/dev/null`.should start_with(
        "ERROR: missing git-gpg command"
      )
      $?.success?.should be_false
    end
    it "does not show help" do
      `#{git_gpg} #{args} 2>/dev/null`.should be_empty
      $?.success?.should be_false
    end
  end
end
