import React, { Component } from 'react';
import { AppRegistry } from 'react-native';
import { AugmentPlayerSDK } from 'react-native-augment';
import RootStack from './src/RootStack';

// Demo credentials, please replace with yours
AugmentPlayerSDK.init({
  id:  "357fee36746668573ceb2f5957c4869ee1a62a112639bac9b0fae43c7c431692",
  key: "80ae1420e164e0440d5329067bcdd953e9fa6c63b75c001c06d169a4f11268c5"
});

AugmentPlayerSDK.isARKitAvailable().then( (isAvailable) => {
  console.log('isARKitAvailable=' + isAvailable);
})

export default class App extends Component {
  render() {
    return <RootStack />;
  }
}

AppRegistry.registerComponent('sample_menu', () => App);
