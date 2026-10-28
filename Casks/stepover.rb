cask "stepover" do
  version "0.3.0"
  sha256 "454374d1cc0afc4e2e3b6feeeb3d404588942a05b1ee0292a7162d411945047d"

  url "https://github.com/rudolphh/stepover/releases/download/v#{version}/Stepover-#{version}.zip"
  name "Stepover"
  desc "Run Windows games with Wine built from CrossOver's source, D3DMetal, DXMT and DXVK"
  homepage "https://github.com/rudolphh/stepover"

  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on formula: "winetricks"

  app "Stepover.app"
  binary "#{appdir}/Stepover.app/Contents/MacOS/stepover-cli", target: "stepover"

  # Signed for this Mac only (no Apple Developer ID), like Sikarugir: clear the download flag
  # and sign locally so Gatekeeper lets it open.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-drs", "com.apple.quarantine", "{{appdir}}/Stepover.app"]
    run "/usr/bin/codesign", args: ["--force", "--deep", "-s", "-", "{{appdir}}/Stepover.app"]
  end

  zap trash: [
    "~/Library/Application Support/Stepover",
    "~/Library/Logs/Stepover",
  ]

  caveats do
    requires_rosetta
    <<~EOS
      Stepover downloads its Wine runtime (289 MB) the first time it opens.
      Not affiliated with CodeWeavers or Apple. Apple's D3DMetal is included for
      non-commercial use on Apple hardware only.
    EOS
  end
end
