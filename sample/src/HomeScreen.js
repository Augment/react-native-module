import React, { Component } from 'react'
import { View, Text, StyleSheet, Button, Image } from 'react-native';
import { StackNavigator } from 'react-navigation';
import { YellowBox } from 'react-native';

export default class HomeScreen extends React.Component {
  render() {
    return (
      <View style={{ flex: 1, flexDirection: "column", alignItems: 'center', justifyContent: 'center' }}>
      <Text>Augment React Native Sample</Text>
      <Button style={styles.button}
          title="Open AR"
          onPress={() => this.props.navigation.navigate('ARScreen', {
              productToSearch: {
                identifier: "3",
                brand: "Apple",
                name: "Ipad"
              }
          })} />
      </View>
    );
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
