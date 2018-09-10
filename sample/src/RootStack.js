import { StackNavigator } from 'react-navigation'
import HomeScreen from './HomeScreen'
import ARScreen from './ARScreen';

const RootStack = StackNavigator(
  {
    Home: {
      screen: HomeScreen,
    },
    ARScreen: {
      screen: ARScreen,
    }
  },
  {
    initialRouteName: 'Home',
  }
);

export default RootStack;
