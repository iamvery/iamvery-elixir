# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.10.0] - 2023-04-28

### Added
- New function for easily opening current state of pipeline up in a browser. See #6 and #18

### Fixes
- Incorrect return value for rendered HTML prevents pipelining. See #12

## [0.9.0] - 2023-01-18

### Added
- Port over duration Ecto types from a project I've been working on. See #14

## [0.8.1] - 2022-12-12

### Fixes
- Invalid function signature for `follow/1`. See #11

## [0.8.0] - 2022-12-12

### Added
- New `follow/1` function to follow a redirect w/o click. See #10

## [0.7.0] - 2022-12-05

### Added
- New `Iamvery.Phoenix.LiveView.TestHelpers.assert_visible` and `refute_visible` functions added. See #7

## [0.6.0] - 2022-10-19

### Added
- New `Iamvery.Phoenix.LiveView.TestHelpers.follow/3` function added in place of `click`'s `opts`.

### Changes
- The `opts` argument is no longer included for `Iamvery.Phoenix.LiveView.TestHelpers.click/3`.
- The `opts` argument is no longer included for `Iamvery.Phoenix.LiveView.TestHelpers.submit_form/3` function.

## 0.1.0 - [0.5.0] - 2022-10-19
Introduction of `Iamvery.Phoenix.LiveView.TestHelpers`.

[Unreleased]: https://github.com/iamvery/iamvery-elixir/compare/v0.9.0...HEAD
[0.9.0]: https://github.com/iamvery/iamvery-elixir/compare/v0.8.1...v0.9.0
[0.8.1]: https://github.com/iamvery/iamvery-elixir/compare/v0.8.0...v0.8.1
[0.8.0]: https://github.com/iamvery/iamvery-elixir/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/iamvery/iamvery-elixir/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/iamvery/iamvery-elixir/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/iamvery/iamvery-elixir/releases/tag/v0.5.0
