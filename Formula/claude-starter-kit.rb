class ClaudeStarterKit < Formula
  desc "Agentic working kit for Claude Code — disciplined project scaffolding"
  homepage "https://github.com/byerlikaya/claude-starter-kit"
  url "https://github.com/byerlikaya/claude-starter-kit/releases/download/v2.12.0/claude-starter-kit-2.12.0.tgz"
  sha256 "427424cc67dc4a1a601f71d660423f4b64c813d4080c297ad32fdb6188f795da"
  version "2.12.0"
  license "MIT"

  def install
    libexec.install "start.sh", "adopt.sh", "claude-starter", "VERSION"
    (bin/"claude-starter-kit").write <<~SH
      #!/bin/bash
      # Stage the bundled payload in a temp dir so start.sh's self-cleanup is harmless.
      stage="$(mktemp -d)"
      cp -R "#{libexec}/." "$stage/"
      case "${1:-}" in
        adopt|update) script=adopt.sh; shift ;;
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
