# Development

**Requirements**

```
brew install swiftformat
brew install swiftlint
brew install go-task
```

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

## Release

1. Increase version number in `VERSION`
2. `task release` to tag and push
3. `task sha` to print hashes to stdout
4. Make changes in [homebrew-made](https://github.com/oschrenk/homebrew-made) and push
5. `brew update` to update taps
6. `brew upgrade` to upgrade formula

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
