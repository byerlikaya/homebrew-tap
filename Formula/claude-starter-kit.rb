class ClaudeStarterKit < Formula
  desc "Agentic working kit for Claude Code — disciplined project scaffolding"
  homepage "https://github.com/byerlikaya/claude-starter-kit"
  url "https://github.com/byerlikaya/claude-starter-kit/releases/download/v1.0.4/claude-starter-kit-1.0.4.tgz"
  sha256 "39beb5f48929364a57a56e72bef104216e580efdfbc688c44f89b1173aab4416"
  version "1.0.4"
  license "MIT"

  def install
    libexec.install "start.sh", "update.sh", "claude-starter", "VERSION"
    (bin/"claude-starter-kit").write <<~SH
      #!/bin/bash
      # Stage the bundled payload in a temp dir so start.sh's self-cleanup is harmless.
      stage="$(mktemp -d)"
      cp -R "#{libexec}/." "$stage/"
      case "${1:-}" in
        adopt|update) script=update.sh; shift ;;
        init)         script=start.sh;  shift ;;
        *)            script=start.sh ;;
      esac
      bash "$stage/$script" "$@"; rc=$?
      rm -rf "$stage"
      exit $rc
    SH
  end

  test do
    assert_match "Usage", shell_output("#{bin}/claude-starter-kit --help 2>&1")
  end
end
