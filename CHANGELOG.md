## 3.2.1

- Support for `build` package `>=3.0.0`

## 3.2.0

- Added global configuration support for `nomap` and `notraverse` flags via `build.yaml`
- New `notraverse` flag to control dot notation access (`messages['nested.message']`)
- Local override support: use `map`/`traverse` flags to override global `nomap`/`notraverse` settings
- Enhanced test coverage for new functionality

## 3.1.0

- Bump the min sdk to `3.6.0`
- Update `dart_style` constraint to `^3.0.0`
- Updated other dependencies

## 3.0.0-alpha.1

- support for custom types and custom imports
- added docs for region support

## 2.1.0

- new 'prenullsafe' flag, which generate 'pre null safe' Dart code ('String' instead of 'String?')

## 2.0.2

- new nothrow flag

## 2.0.1

- Nullsafe README

## 2.0.0

- Nullsafe release

## 2.0.0-nullsafety.2

- Update dependencies

## 2.0.0-nullsafety.1

- migration to null safety

## 1.1.0

- polishing, fine-tuning, release

## 1.0.0

- possibility to customize generator behaviour with flags
- map operator is now generated only for objects with 'map' flag

## 0.5.0

- even more pedantic friendly - resolved all warnings

## 0.4.0

- pedantic friendly - both project source files and generated messages

## 0.3.0

- more benevolent dependencies (for web use angular: 5.3.1)

## 0.2.0

- Upgrade to Dart 2.5.1 and build_runner 1.7.1
- added possibility to access messages with string keys, not only Dart identifiers (i.e. `m['generic.ok']`)
- output is formatted with Dartfmt

## 0.1.0

- Seems good, let's move up

## 0.0.2

- More README

## 0.0.1

- Initial version, created by Stagehand
- Just getting started.
