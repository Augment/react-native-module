/**
* Wrapper for Augment React
* documentation at: https://developers.augment.com
*/
'use strict';

import React, { Component } from 'react'
import {
  Platform,
  NativeEventEmitter,
  NativeModules,
  requireNativeComponent,
  ViewPropTypes,
  UIManager
} from 'react-native'
import PropTypes from 'prop-types'

/**
* This is the Native class interface for javascript only parts
*/
var RNAugmentPlayerSDK = NativeModules.RNAugmentPlayerSDK

// These are defined by the Native module and are main event sent by Augment SDK
// AugmentReact.AUGMENT_EVENT_LOADING_PROGRESS
// AugmentReact.AUGMENT_EVENT_LOADING_OVER

/**
* Extended version of the Player
* That way we can enforce specifics behaviours
*/
export default class AugmentSDK {
  static Constants = {
    AppID: RNAugmentPlayerSDK.AppID,
    AppKey: RNAugmentPlayerSDK.AppKey,
    Identifier: RNAugmentPlayerSDK.Identifier,
    Brand: RNAugmentPlayerSDK.Brand,
    Name: RNAugmentPlayerSDK.Name,
    EAN: RNAugmentPlayerSDK.EAN,
  };

  static isARKitAvailable(): Promise<Array<FaceFeature>> {
    if (Platform.OS === 'ios') {
      return RNAugmentPlayerSDK.isARKitAvailable()
    } else {
      return new Promise(resolve => { resolve(false); });
    }
  }
}
