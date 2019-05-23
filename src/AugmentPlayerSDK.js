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
const RNAugmentPlayerSDK = NativeModules.RNAugmentPlayerSDK

// These are defined by the Native module and are main event sent by Augment SDK
// AugmentReact.AUGMENT_EVENT_LOADING_PROGRESS
// AugmentReact.AUGMENT_EVENT_LOADING_OVER

/**
* Extended version of the Player
* That way we can enforce specifics behaviours
*/
export default class AugmentPlayerSDK {
  static Constants = {
    AppID: RNAugmentPlayerSDK.AppID,
    AppKey: RNAugmentPlayerSDK.AppKey,
    Identifier: RNAugmentPlayerSDK.Identifier,
    Brand: RNAugmentPlayerSDK.Brand,
    Name: RNAugmentPlayerSDK.Name,
    EAN: RNAugmentPlayerSDK.EAN,
  };

  static init({id, key}): Promise {
      RNAugmentPlayerSDK.init({
        id:  id,
        key: key
      });
  }

  static async checkIfModelDoesExistForUserProduct(productToSearch): Promise {
      return await RNAugmentPlayerSDK.checkIfModelDoesExistForUserProduct(productToSearch)
  }

  static isARKitAvailable(): Promise<Boolean> {
    return new Promise(resolve => {
      RNAugmentPlayerSDK.isARKitAvailable((isAvailable) => {
        resolve(isAvailable);
      })
    });
  }
}
