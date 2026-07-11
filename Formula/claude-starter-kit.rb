class ClaudeStarterKit < Formula
  desc "Agentic working kit for Claude Code — disciplined project scaffolding"
  homepage "https://github.com/byerlikaya/claude-starter-kit"
  url "https://github.com/byerlikaya/claude-starter-kit/releases/download/v1.1.6/claude-starter-kit-1.1.6.tgz"
  sha256 "f7a0434bf746bebd19260ca89f36225c2a28f472ae4cee5837f632b6b45bd80b"
  version "1.1.6"
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
