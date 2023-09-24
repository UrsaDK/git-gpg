require "./spec_helper"

Spectator.describe GitGPG do
  describe "module" do
    subject { described_class }

    it { is_expected.to respond_to(:main) }
    it { is_expected.to respond_to(:quiet?) }
    it { is_expected.to respond_to(:command) }
    it { is_expected.to respond_to(:verbosity) }

    # Imported via a macro
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:version) }
    it { is_expected.to respond_to(:authors) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:repository) }
    it { is_expected.to respond_to(:crystal) }
    it { is_expected.to respond_to(:license) }
  end

  describe "verbosity" do
    around_each do |proc|
      puts "around_each :: top"
      default_verbosity = described_class.verbosity
      proc.call
      described_class.verbosity = default_verbosity
      puts "around_each :: end"
    end

    context "with defaults" do
      before_each { puts "before_each" }

      it { expect(described_class.verbosity).to eq(GitGPG::Verbosity::Normal) }
      it { expect(described_class.quiet?).to be_false }
    end

    # context "when set to Normal" do
    #   before_each { described_class.verbosity = GitGPG::Verbosity::Normal }

    #   it { expect(described_class.verbosity).to eq(GitGPG::Verbosity::Normal) }
    #   it { expect(described_class.quiet?).to be_false }
    # end

    # context "when set to Quiet" do
    #   before_each { described_class.verbosity = GitGPG::Verbosity::Quiet }

    #   it { expect(described_class.verbosity).to eq(GitGPG::Verbosity::Quiet) }
    #   it { expect(described_class.quiet?).to be_true }
    # end
  end

  describe "command" do
    subject { described_class.command.call }

    context "with defaults" do
      it { is_expected.to be_a(String) }
      it { is_expected.to start_with("Usage:") }
    end
  end
end
