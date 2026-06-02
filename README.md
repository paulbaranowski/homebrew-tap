# paulbaranowski/homebrew-tap

Homebrew tap for standalone CLIs extracted from
[wild-horses](https://github.com/paulbaranowski/wild-horses).

## plan-keeper

The I/O backend behind the `plan-keeper` Claude Code skills, shipped as a
standalone command-line tool. It manages a per-repo tree of markdown plans
under `~/plans/<repo>/`: save plans, list/archive them, read and edit their
frontmatter, and push them to Linear or Jira. Zero dependencies (pure stdlib).

```sh
brew install paulbaranowski/tap/plan-keeper
```

Then:

```sh
plan-keeper list                     # active plans for the current repo
plan-keeper list-repos               # every repo under ~/plans/ with counts
plan-keeper save --topic "notes" <<'EOF'
...plan body...
EOF
plan-keeper archive --file <name>    # move a plan to done/ with a stamp
plan-keeper push --name linear --file <path>   # file it as a ticket
plan-keeper --help                   # all subcommands
```

It writes the same `~/plans/<repo>/` tree the Claude Code plugin uses, so the
plugin and this CLI interoperate directly.

## Releasing a new version

1. In the `wild-horses` repo, bump `version` in
   `plugins/plan-keeper/scripts/pyproject.toml`, then tag and push:

   ```sh
   git tag plan-keeper-v0.1.0
   git push origin plan-keeper-v0.1.0
   ```

2. In this repo, point the formula at the new release and push:

   ```sh
   ./update-formula.sh 0.1.0
   git commit -am "plan-keeper 0.1.0"
   git push
   ```

## Local formula checks

```sh
brew install --build-from-source ./Formula/plan-keeper.rb
brew test plan-keeper
brew audit --strict --new plan-keeper
```
