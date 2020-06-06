require "spec"
require "../src/git-gpg"

GIT_GPG = "#{__DIR__}/../bin/git-gpg"

macro it_responds_to(subject, method)
  it "responds to .{{method}}" do
    {{subject}}.responds_to?(:{{method}}).should be_true
  end
end

macro git_gpg_output(args, expectation)
  it "is returned by: {{args.id}}" do
    `#{GIT_GPG} {{args.id}} 2>&1`.should {{expectation}}
    $?.success?.should be_true
  end
  it "is returned by: --quiet {{args.id}}" do
    `#{GIT_GPG} --quiet {{args.id}} 2>&1`.should {{expectation}}
    $?.success?.should be_true
  end
end

macro git_gpg_stdout(args, expectation)
  it "prints output to STDOUT" do
    `#{GIT_GPG} {{args.id}} 2>/dev/null`.should {{expectation}}
    $?.success?.should be_false
  end
  it "suppresses output to STDOUT in quiet mode" do
    `#{GIT_GPG} --quiet {{args.id}} 2>/dev/null`.should be_empty
    $?.success?.should be_false
  end
end

macro git_gpg_stderr(args, expectation)
  it "prints error to STDERR" do
    `#{GIT_GPG} {{args.id}} 2>&1 >/dev/null`.should {{expectation}}
    $?.success?.should be_false
  end
  it "prints error to STDERR in quiet mode" do
    `#{GIT_GPG} --quiet {{args.id}} 2>&1 >/dev/null`.should {{expectation}}
    $?.success?.should be_false
  end
end
