require "../../spec_helper"

describe GitGPG::Filters::Clean do
  git_gpg = "#{__DIR__}/../../../bin/git-gpg"

  context "help" do
    it "is shown by help for a command with a sub-command" do
      `#{git_gpg} help clean non-existent-file`.should start_with(
        "Usage: #{GitGPG.name} clean [options] <file>"
      )
      $?.success?.should be_true
    end
  end
end
