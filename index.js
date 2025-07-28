/**
 * @format
 */

import {AppRegistry, Text, TextInput} from 'react-native';
import {name as appName} from './app.json';
// import HomeScreen from './src/HomeScreen';
import 'react-native-reanimated'; // Must be the first import
import App from './App';


AppRegistry.registerComponent(appName, () => App);
if (Text.defaultProps == null) {
    Text.defaultProps = {};
    Text.defaultProps.allowFontScaling = false;
  }
  if (TextInput.defaultProps == null) {
    TextInput.defaultProps = {};
    TextInput.defaultProps.allowFontScaling = false;
  }
  