cask "flip" do
  # Both lines are rewritten by Flip's release pipeline. Keep them on one line
  # each and in this shape, or the bump silently stops matching.
  version "0.2.0"
  sha256 "51f993c0c60bbf2cc5eecab6eff0deaafd3fb70eb9c476c5d35496fbe33e189e"

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
