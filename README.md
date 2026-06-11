# paulbaranowski/homebrew-tap

Homebrew tap for Paul Baranowski's standalone command-line tools.

## plan-keeper

The I/O backend behind the `plan-keeper` Claude Code skills, shipped as a
standalone command-line tool. It manages a per-repo tree of markdown plans
under `~/plans/<repo>/`: save plans, list/archive them, read and edit their
frontmatter, and push them to Linear or Jira. Zero dependencies (pure stdlib).
Built from [wild-horses](https://github.com/paulbaranowski/wild-horses).

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

## crew-config

Interactive TUI to create and update groundcrew's `crew.config.json`. Built from
[groundcrew-config](https://github.com/paulbaranowski/groundcrew-config).

```sh
brew install paulbaranowski/tap/crew-config
```

Then:

```sh
crew-config            # edit the global ~/.config/groundcrew/crew.config.json
crew-config --local    # edit ./crew.config.json in the current project
crew-config <path>     # edit the crew.config.json at <path>
crew-config --help     # usage
```

## Releasing a new version

Each formula is built from a pushed git tag on its source repo. `update-formula.sh`
fetches the tag tarball, computes its `sha256`, and rewrites the formula's `url` +
`sha256` lines.

**plan-keeper** (source repo `wild-horses`, tag `plan-keeper-v<version>`):

1. In `wild-horses`, bump `version` in
   `plugins/plan-keeper/scripts/pyproject.toml`, then tag and push:

   ```sh
   git tag plan-keeper-v0.1.0
   git push origin plan-keeper-v0.1.0
   ```

2. In this repo, point the formula at the new release and push:

   ```sh
   ./update-formula.sh plan-keeper 0.1.0
   git commit -am "plan-keeper 0.1.0"
   git push
   ```

**crew-config** (source repo `groundcrew-config`, tag `v<version>`):

1. In `groundcrew-config`, bump `version` in `package.json`, land it on `main`,
   then tag and push:

   ```sh
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. In this repo, point the formula at the new release and push:

   ```sh
   ./update-formula.sh crew-config 1.0.0
   git commit -am "crew-config 1.0.0"
   git push
   ```

## Local formula checks

```sh
brew install --build-from-source ./Formula/<formula>.rb
brew test <formula>
brew audit --strict --new <formula>
```
