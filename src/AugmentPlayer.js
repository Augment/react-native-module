import React, { Component } from 'react'
import {
  NativeEventEmitter,
  NativeModules,
  requireNativeComponent,
  ViewPropTypes,
  UIManager
} from 'react-native'
import PropTypes from 'prop-types'

const RNAugmentPlayerManager = NativeModules.RNAugmentPlayerManager

/**
* Extended version of the Player
* That way we can enforce specifics behaviours
*/
class AugmentPlayer extends React.Component<PropsType, StateType> {
  static Constants = {
    ModelGesture: RNAugmentPlayerManager.ModelGesture,
    TrackingStatus: RNAugmentPlayerManager.TrackingStatus
  };

  static propTypes = {
    ...ViewPropTypes,
    // loaderCallback((loaderObject: [progress: int, show: bool]) => void)
    loaderCallback: PropTypes.func,
    // onPlayerReady(player: AugmentReactPlayer, errorCallback: (error: [error: string]) => void)
    onPlayerReady: PropTypes.func,
    onInitializationFailed: PropTypes.func,
    onTrackingStatusChanged: PropTypes.func,
    onModelGesture: PropTypes.func,
  }

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <RNAugmentPlayer
      {...this.props}
      ref={this._setReference}
      onPlayerReady={this._onPlayerReady}
      onInitializationFailed={this._onInitializationFailed}
      onLoadingProgressDidChange={this._handleLoadingProgress}
      onLoadingDidFinish={this._handleLoadingOver}
      onTrackingStatusChanged={this._onTrackingStatusChanged}
      onModelGesture={this._onModelGesture}
      />
    );
  }

  _setReference = (ref: ?Object) => {
    if (ref) {
      this._playerRef = ref;
      this._playerHandle = findNodeHandle(ref);
    } else {
      this._playerRef = null;
      this._playerHandle = null;
    }
  };

  _onPlayerReady = () => {
    if (!this.props.onPlayerReady) {
      this.props.onPlayerReady(this);
    }
  }

  _onInitializationFailed = () => {
    if (!this.props.onInitializationFailed) {
      this.props.onInitializationFailed(this);
    }
  }

  _handleLoadingProgress = ({ nativeEvent }: EventCallbackArgumentsType) => {
    if (this.props.loaderCallback) {
      this.props.loaderCallback({"show": true, "progress": nativeEvent.progress});
    }
  }

  _handleLoadingOver = () => {
    if (this.props.loaderCallback) {
      this.props.loaderCallback({"show": false, "progress": 100});
    }
  }

  _onTrackingStatusChanged = ({ nativeEvent }: EventCallbackArgumentsType) => {
    if (this.props.onTrackingStatusChanged) {
      this.props.onTrackingStatusChanged(nativeEvent);
    }
  }

  _onModelGesture = ({ nativeEvent }: EventCallbackArgumentsType) => {
    if (this.props.onModelGesture) {
      this.props.onModelGesture(nativeEvent);
    }
  }

  async recenterProducts() {
    return await RNAugmentPlayerManager.recenterProducts(this._playerHandle);
  }

  async takeScreenshot() {
    return await RNAugmentPlayerManager.takeScreenshot(this._playerHandle);
  }

  async addProduct(product) {
    return await RNAugmentPlayerManager.addProduct(product, this._playerHandle);
  }
}

const RNAugmentPlayer = requireNativeComponent('RNAugmentPlayer', AugmentPlayer, {
  nativeOnly: {
    onPlayerReady: true,
    onInitializationFailed: true,
    onTrackingStatusChanged: true,
    onModelGesture: true
  },
});
