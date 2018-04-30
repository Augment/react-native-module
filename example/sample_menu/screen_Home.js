import React from 'react';
import { View, Text, StyleSheet, Button } from 'react-native';
import { StackNavigator } from 'react-navigation';
import { YellowBox } from 'react-native';
import screenAR from './screen_AR';

class HomeScreen extends React.Component {
  render() {
    return (
      <View style={{ flex: 1, flexDirection: "column", alignItems: 'center', justifyContent: 'center' }}>
      <Text>Augment React Native Sample</Text>
      <Button style={styles.button}
          title="Open AR"
          onPress={() => this.props.navigation.navigate('ARScreen')} />
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
  'Module'
]);
