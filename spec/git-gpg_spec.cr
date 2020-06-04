require "yaml"
require "./spec_helper"

describe GitGPG do
  it "defines the entry point" do
    GitGPG.responds_to?(:main).should be_true
  end
end
