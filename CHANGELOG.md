# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0] - 2022-10-19

### Added
- New `Iamvery.Phoenix.LiveView.TestHelpers.follow/3` function added in place of `click`'s `opts`.

### Changes
- The `opts` argument is no longer included for `Iamvery.Phoenix.LiveView.TestHelpers.click/3`.
- The `opts` argument is no longer included for `Iamvery.Phoenix.LiveView.TestHelpers.submit_form/3` function.

## 0.1.0 - [0.5.0] - 2022-10-19
Introduction of `Iamvery.Phoenix.LiveView.TestHelpers`.

[Unreleased]: https://github.com/iamvery/iamvery-elixir/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/iamvery/iamvery-elixir/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/iamvery/iamvery-elixir/releases/tag/v0.5.0
