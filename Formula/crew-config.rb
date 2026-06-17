class CrewConfig < Formula
  desc "Interactive TUI to create and update groundcrew's crew.config.json"
  homepage "https://github.com/paulbaranowski/groundcrew-config"
  # Built from a `v*` tag on the groundcrew-config repo. The tsup bundle leaves
  # ink/react/cosmiconfig/@clipboard-health/groundcrew as runtime imports, so the
  # formula builds at install time and ships a pruned production node_modules
  # beside dist — not just dist/cli.js.
  url "https://github.com/paulbaranowski/groundcrew-config/archive/refs/tags/v1.0.16.tar.gz"
  sha256 "915d8969d43bbf5dfd90bac5a5dc059aac9c93e6fbca9f5f929ae2a3dc910104"
  license "MIT"

  depends_on "node"

  def install
    # Install dev deps too (tsup builds the bundle), build, then drop dev deps.
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev"
    # Node walks up from dist/cli.js to resolve the bare ESM imports, so the
    # bundle, the production deps, and package.json ("type":"module") all travel
    # into libexec together; the bin entry is a symlink to the shebang'd bundle.
    libexec.install "dist", "node_modules", "package.json"
    bin.install_symlink libexec/"dist/cli.js" => "crew-config"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crew-config --version")
  end
end
