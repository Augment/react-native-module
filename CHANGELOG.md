# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [3.0.0-beta.4] - 2019-10-03
### Changed
- React Native and dependencies updated: "react": "16.9.0"; "react-native": "0.61.2"

## [3.0.0-beta.3] - 2019-06-07
### Changed
- Updated AndroidSDK `2.0.0-beta1`

## [3.0.0-beta.2] - 2019-06-07
### Changed
- Updated AndroidSDK `2.0.0-alpha4`

## [3.0.0-beta.1] - 2019-05-22
### Added
- AndroidSDK support

### Changed
- React Native and dependencies updated: "react": "16.8.3"; "react-native": "0.59.5"

## [2.0.0] - 2018-09-10
### Changed
- Using iOS SDK v4.0, removing the dependency on Vuforia

### Removed
- Android SDK has been removed temporarily and all possible calls to `AugmentPlayerSDK` and `AugmentPlayer` have been stubbed.

### Breaking changes
- `AugmentReact` and `AugmentReactPlayer` have been renamed `AugmentPlayerSDK` and `AugmentPlayer` to match native names.
- Native listeners (gesture and tracking) have been removed in favor of component props
- `addProduct`, `takeScreenshot` and `recenterProducts` have moved to AugmentPlayer component
instead of being global functions.

## [1.5.1] - 2018-08-09
### Added
- iOS: Expose isARKitAvailable

## [1.5.0] - 2018-07-25
### Changed
- Using iOS SDK with ARKit

### Added
- AR Tracking listener
- Model Gesture listener

## [1.4.0] - 2018-05-30
### Changed
- New code structure

### Added
- Exposed takeScreenshot method

### Fixed
- iOS: Second AR launch not working
- Android: Two models appear when coming back from background

## [1.3.3] - 2018-03-20
### Changed
- Augment SDK version to `1.0.3`

### Fixed
- Catch exceptions on the de-initialisation of Vuforia and lifecycle events.

## [1.3.2] - 2018-03-06
### Fixed
- Avoid exception for Product being null

## [1.3.1] - 2018-03-01
### Changed
- Default path for Framework (Header) Search's

## [1.3.0] - 2018-02-27
### Fixed
- augmentSDK header imports

## [1.2.0] - 2018-02-12
### Changed
- Use PropTypes

## [1.1.0] - 2017-05-10
### Changed
 - Use promise instead of callbacks, please se the doc to check how it will affect your code

## [1.0.1] - 2017-05-05
### Added
 - Documentation

### Fixed
 - Wrong index file for package

## [1.0.0] - 2017-05-02
### Added
 - First public version
