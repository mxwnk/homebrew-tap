cask "flip" do
  # Both lines are rewritten by Flip's release pipeline. Keep them on one line
  # each and in this shape, or the bump silently stops matching.
  version "0.1.0"
  sha256 "5d4debbaf7bdbebc21046ab362ffeb0487edc679867265c12bfc0c5ddf15b88c"

  url "https://github.com/mxwnk/flip/releases/download/v#{version}/Flip-#{version}.dmg"
  name "Flip"
  desc "Window switcher that gets out of the way"
  homepage "https://github.com/mxwnk/flip"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Flip.app"

  # Flip is signed with its own certificate rather than notarised, so Gatekeeper
  # refuses the first launch, and macOS 26 no longer offers the Control-click way
  # around that. Notarising instead would change the signature that Accessibility
  # and Screen Recording are keyed to, revoking both on every existing install.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Flip.app"]
  end

  uninstall launchctl: "dev.mxwnk.Flip.login",
            quit:      "dev.mxwnk.Flip"

  zap trash: [
    "~/Library/Application Support/Flip",
    "~/Library/Preferences/dev.mxwnk.Flip.plist",
  ]
end
