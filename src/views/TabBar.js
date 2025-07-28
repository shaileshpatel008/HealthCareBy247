import React, { useState } from "react";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { Image, Linking, View, TouchableOpacity } from "react-native";
import { Text } from "react-native-gesture-handler";
import { SafeAreaView } from "react-native-safe-area-context";
import { createNativeStackNavigator } from "@react-navigation/native-stack";

import styles from "../styles/styleTabBar";
import HomeScreen from "./Home";
import ContactUsScreen from "./Contactus";
import { useConfig } from "../context/ConfigContext";
import PromptBox from "../components/PromptBox";

const HomeStack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();

const icons = {
  home: require("../assets/home-icon.png"),
  contactus: require("../assets/contact-icon.png"),
  callus: require("../assets/call-icon.png"),
  whatsapp: require("../assets/whatsapp-icon.png"),
};

function HomeStackNavigator() {
  return (
    <HomeStack.Navigator screenOptions={{ headerShown: false }}>
      <HomeStack.Screen name="HomeScreen" component={HomeScreen} />
    </HomeStack.Navigator>
  );
}

const MyTabs = () => {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarHideOnKeyboard: true,
      })}
      tabBar={(props) => <CustomTabBar {...props} />}
    >
      <Tab.Screen name="Home" component={HomeStackNavigator} />
      <Tab.Screen
        name="ContactUs"
        component={ContactUsScreen}
        options={{ tabBarLabel: "Contact Us" }}
      />
      <Tab.Screen
        name="CallUs"
        component={HomeStackNavigator}
        options={{ tabBarLabel: "Call Us" }}
      />
      <Tab.Screen name="WhatsApp" component={HomeStackNavigator} />
    </Tab.Navigator>
  );
};

const CustomTabBar = ({ state, descriptors, navigation }) => {
  const { config } = useConfig();
  const [whatsappPromptVisible, setWhatsappPromptVisible] = useState(false);
  const [callPromptVisible, setCallPromptVisible] = useState(false);

  const openWhatsApp = () => {
    const url = `https://wa.me/+91${config.WhatsAppNo}?text=Hello`;
    Linking.openURL(url).catch((err) =>
      console.error("Error opening WhatsApp", err)
    );
  };

  const makeCall = () => {
    const phoneNumber = config.CallusNo.split("/")[0].trim();
    const url = `tel:+91${phoneNumber}`;
    Linking.openURL(url).catch((err) =>
      console.error("Error making call", err)
    );
  };

  const onPress = (route) => {
    if (route.name === "WhatsApp") {
      setWhatsappPromptVisible(true);
    } else if (route.name === "CallUs") {
      setCallPromptVisible(true);
    } else {
      navigation.navigate(route.name);
    }
  };

  return (
    <SafeAreaView edges={[]} style={styles.safeArea}>
      <View style={styles.tabBarContainer}>
        {state.routes.map((route, index) => {
          const { options } = descriptors[route.key];
          const label = options.tabBarLabel ?? route.name;
          const isFocused = state.index === index;
          const iconSource = icons[route.name.toLowerCase().replace(" ", "")];

          return (
            <TouchableOpacity
              key={index}
              onPress={() => onPress(route)}
              style={[styles.tabItem, isFocused && styles.activeTab]}
            >
              <Image
                source={iconSource}
                style={[styles.icon, isFocused && styles.activeIcon]}
                resizeMode="contain"
              />
              <Text style={[styles.label, isFocused && styles.activeLabel]}>
                {label}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      {/* WhatsApp Prompt Box */}
      <PromptBox
        visible={whatsappPromptVisible}
        title="Proceed to WhatsApp?"
        description="Do you want to continue to WhatsApp?"
        onCancel={() => {
          setWhatsappPromptVisible(false);
          console.log("WhatsApp canceled");
        }}
        onConfirm={() => {
          setWhatsappPromptVisible(false);
          openWhatsApp();
        }}
      />

      {/* Call Us Prompt Box */}
      <PromptBox
        visible={callPromptVisible}
        title="Initiate Call!"
        description="Are you sure you want to call?"
        onCancel={() => {
          setCallPromptVisible(false);
          console.log("Call canceled");
        }}
        onConfirm={() => {
          setCallPromptVisible(false);
          makeCall();
        }}
      />
    </SafeAreaView>
  );
};

export default MyTabs;
