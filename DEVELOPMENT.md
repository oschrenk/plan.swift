# Development

**Requirements**

Xcode supplies the Swift compiler. Everything around it comes from the flake:

```
nix develop
```

Or, with [direnv](https://direnv.net/), `direnv allow` once and the shell loads
on `cd`.

`swiftformat`, `swiftlint`, `go-task`, `jq` and `cachix` live in that shell. It
deliberately does *not* provide `swift` or `sourcekit-lsp`: nixpkgs only carries
5.10.1, which cannot build this package (see below), and having it on `PATH`
would shadow the Xcode toolchain that can.

## Tasks

- `task build` Build project
- `task run` Run example
- `task test` Run tests
- `task format` Format using rules in `.swiftformat`
- `task lint` Lint using rules in `.swiftlint`
- `task install` Install app in `$HOME/.local/bin/`
- `task uninstall` Removes app from `$HOME/.local/bin/`
- `task artifacts` Produces artifact in `.build/release/`
- `task tag` Pushes git tag from `VERSION`
- `task release` Creates GitHub release from artifacts
- `task sha` Prints hashes from artifacts
- `task clean` Removes build directory `.build`
- `task nix-hash` Points `flake.nix` at the freshly published release artifact

## Nix

`nix build .#plan` does **not** compile from source. nixpkgs ships Swift 5.10.1
and its `swiftpm` is built without `CompilerPluginSupport`, so evaluating the
`swift-case-paths` manifest (a transitive dependency of `swift-parsing`) fails
with `no such module 'CompilerPluginSupport'`. Until nixpkgs carries a
macro-capable Swift 6, the flake packages the release artifact that
`task release` uploads to GitHub.

That is why `flake.nix` carries a `hash` next to the version, and why
`task nix-hash` has to run *after* the release exists.

## Release

Do not push the version bump on its own — a `VERSION` that has no matching hash
yet turns the `build` workflow red. Amend instead.

0. `task install` to test release
1. Increase version number in `VERSION` and commit, but **do not push**
2. `task release` to tag, push the tag and create the GitHub release
3. `task nix-hash` to update the hash in `flake.nix`
4. `git commit --amend` and `git push`
5. `task sha | cut -d ' ' -f 1 | pbcopy` to copy the build hash to the clipboard
6. Make changes in [homebrew-made](https://github.com/oschrenk/homebrew-made) and commit and push
7. `task uninstall` To remove local installation
8. `brew update` to update taps
9. `brew upgrade` to upgrade formula

## Issues

### `xcrun: error: unable to lookup item 'PlatformPath'`

```
xcrun: error: unable to lookup item 'PlatformPath' from command line tools installation
xcrun: error: unable to lookup item 'PlatformPath' in SDK '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk'
```

Try fixing the SDK path (yours appears incorrect):

`$ xcrun --show-sdk-path --sdk macosx`

You might have this result:

`/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk`

Switch the default SDK location by invoking:

`$ sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer`

See also https://stackoverflow.com/a/43418980

## Similar projects

- [mcal](https://github.com/0ihsan/mcal)
- [icalBuddy](https://hasseg.org/icalBuddy/)
