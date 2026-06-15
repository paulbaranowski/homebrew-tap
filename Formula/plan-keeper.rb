class PlanKeeper < Formula
  include Language::Python::Virtualenv

  desc "Organize markdown plans in ~/plans and push them to Linear or Jira"
  homepage "https://github.com/paulbaranowski/wild-horses"
  # Built from the wild-horses repo at a `plan-keeper-v*` tag. The CLI source is
  # a single, zero-dependency stdlib module (the plan-keeper plugin's backend);
  # this formula packages that same file as the `plan-keeper` binary.
  url "https://github.com/paulbaranowski/wild-horses/archive/refs/tags/plan-keeper-v6.8.0.tar.gz"
  sha256 "101f94b820d70f1f97d6d9b1fa7dd77eedc72acac9d487cc37f5bac527cbbafd"
  license "MIT"

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    # The pyproject.toml lives beside the module inside the plugin tree; install
    # that subdirectory. Zero third-party deps, so there are no resources.
    venv.pip_install_and_link buildpath/"plugins/plan-keeper/scripts"
  end

  test do
    # Isolate state under the sandboxed test dir, skip git via --override, then
    # save a plan from stdin and confirm it lists back.
    ENV["HOME"] = testpath
    pipe_output("#{bin}/plan-keeper save --override demo --topic smoke", "# smoke test\n")
    assert_match "smoke", shell_output("#{bin}/plan-keeper list --override demo")
  end
end
