import React from "react";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { Image,Linking,View,TouchableOpacity } from "react-native";
import { Text } from "react-native-gesture-handler";
import {  SafeAreaView } from 'react-native-safe-area-context';
import { createNativeStackNavigator } from '@react-navigation/native-stack';

import styles from '../styles/styleTabBar';
import HomeScreen from "./Home";
import ContactUsScreen from "./Contactus";
import { useConfig } from '../context/ConfigContext';

const HomeStack = createNativeStackNavigator();
const TestStack = createNativeStackNavigator();
const PackageStack = createNativeStackNavigator();

// Create Bottom Tab Navigator
const Tab = createBottomTabNavigator();
const cart = createNativeStackNavigator();
// Importing icons (replace with your image paths)
const icons = {
  home: require('../assets/home-icon.png'),
  contactus: require('../assets/contact-icon.png'),
  callus: require('../assets/call-icon.png'),
  whatsapp: require('../assets/whatsapp-icon.png'),
};
  
  // 🏠 Home Stack
function HomeStackNavigator() {
  return (
    <HomeStack.Navigator screenOptions={{ 
      headerShown: false,
      tabBarStyle:{
        
    } }}>
      <HomeStack.Screen name="HomeScreen" component={HomeScreen} />
    </HomeStack.Navigator>
  );
}

const MyTabs = () => {
  
  return (
    <Tab.Navigator
        screenOptions = {({ route }) =>  ({ 
          headerShown: false,
          tabBarHideOnKeyboard: true,
          })}
        tabBar={(props) => <CustomTabBar {...props } 
        />}
      >
        <Tab.Screen name="Home" component={HomeStackNavigator} />
        <Tab.Screen name="ContactUs" component={ContactUsScreen} options={{ tabBarLabel: 'Contact Us' }} />
        <Tab.Screen name="CallUs" component={HomeStackNavigator} options={{ tabBarLabel: 'Call Us' }} />
        <Tab.Screen name="WhatsApp" component={HomeStackNavigator} />
      </Tab.Navigator>
    
  );
};
export default MyTabs;

const CustomTabBar = ({ state, descriptors, navigation }) => {
  const { config } = useConfig();
  const openWhatsApp = () => {
    // Open WhatsApp without changing the tab
    const url = `https://wa.me/+91${config.WhatsAppNo}?text=Hello`;
    Linking.openURL(url).catch(err => console.error('Error opening WhatsApp', err));
  };
  
  const makeCall = () => {
    const phoneNumber = config.CallusNo.split('/')[0].trim();
    const url = `tel:+91${phoneNumber}`;
    Linking.openURL(url).catch(err => console.error('Error making call', err));
  };
  const onPress = (route) => {
    if (route.name === 'WhatsApp') {
      openWhatsApp();
    } else if (route.name === "CallUs")
    {
    makeCall();
    }
    else {
      // Navigate to the selected tab
      navigation.navigate(route.name);
    }
  };
  return (
    <SafeAreaView edges={['bottom']} style={styles.safeArea}>
    <View style={styles.tabBarContainer}>
      {state.routes.map((route, index) => {
        const { options } = descriptors[route.key];
        const label = options.tabBarLabel ?? route.name;

        const isFocused = state.index === index;
        // Define the correct icon for each tab
        const iconSource = icons[route.name.toLowerCase().replace(' ', '')]; 
        return (
          <TouchableOpacity
            key={index}
            onPress={() => onPress(route)} //navigation.navigate(route.name)
            style={[styles.tabItem, isFocused && styles.activeTab]}
          >
            <Image source={iconSource} style={[styles.icon, isFocused && styles.activeIcon]} resizeMode="contain" />
            <Text style={[styles.label, isFocused && styles.activeLabel]}>{label}</Text>
          </TouchableOpacity>
        );
      })}
    </View>
    </SafeAreaView>
  );
};
