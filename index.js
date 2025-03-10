/**
 * @format
 */

import {AppRegistry} from 'react-native';
import {name as appName} from './app.json';
// import HomeScreen from './src/HomeScreen';
import 'react-native-reanimated'; // Must be the first import
import App from './App';


AppRegistry.registerComponent(appName, () => App);
