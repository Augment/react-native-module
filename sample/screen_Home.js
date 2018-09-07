import React from 'react';
import { View, Text, StyleSheet, Button, Image } from 'react-native';
import { StackNavigator } from 'react-navigation';
import { YellowBox } from 'react-native';
import screenAR from './screen_AR';
import { AugmentPlayerSDK } from 'react-native-augment';

// Demo credentials, please replace with yours
var credentials = {
    AugmentSDK.AppID:  "357fee36746668573ceb2f5957c4869ee1a62a112639bac9b0fae43c7c431692",
    AugmentSDK.AppKey: "80ae1420e164e0440d5329067bcdd953e9fa6c63b75c001c06d169a4f11268c5"
}

AugmentPlayerSDK.init(credentials);

AugmentPlayerSDK.isARKitAvailable((_, isAvailable) => {
  console.log('isARKitAvailable=' + isAvailable);
})

class HomeScreen extends React.Component {
  render() {
    return (
      <View style={{ flex: 1, flexDirection: "column", alignItems: 'center', justifyContent: 'center' }}>
      <Text>Augment React Native Sample</Text>
      <Button style={styles.button}
          title="Open AR"
          onPress={() => this.props.navigation.navigate('ARScreen', {
              productToSearch: {
                identifier: "5",
                brand: "Apple",
                name: "Ipad"
              }
          })} />
      </View>
    );
  }
}

const RootStack = StackNavigator(
  {
    Home: {
      screen: HomeScreen,
    },
    ARScreen: {
        screen: screenAR,
    }
  },
  {
    initialRouteName: 'Home',
  }
);

export default class App extends React.Component {
  render() {
    return <RootStack />;
  }
}

const styles = StyleSheet.create({
    buttonContainer: {
        flex: 0,
        margin: 8,
        borderRadius: 5,
        flexDirection: "row",
        justifyContent: "space-around"
    },
    button: {
        flex: 1,
        height: 48,
        backgroundColor: "skyblue"
    }
});

YellowBox.ignoreWarnings([
  'Warning: componentWillMount is deprecated',
  'Warning: componentWillReceiveProps is deprecated',
  'Warning: isMounted(...) is deprecated',
  'Module',
  'Warning: Class RCTxxModule'
]);
