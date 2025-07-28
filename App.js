/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */
import "react-native-reanimated"; // Must be the first import
import React, { useCallback, useEffect, useRef, useState } from "react";
import {
  SafeAreaContext,
  SafeAreaProvider,
  SafeAreaView,
  useSafeAreaInsets,
} from "react-native-safe-area-context";
import { NavigationContainer, useFocusEffect } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { createDrawerNavigator } from "@react-navigation/drawer";
import colors from "./src/utils/colors";
import { ConfigProvider, useConfig } from "./src/context/ConfigContext"; // Import the Context Provider and custom hook
import { CartProvider } from "./src/context/CartContext"; // Import the Context Provider and custom hook
import Geolocation from "@react-native-community/geolocation";
import { request, PERMISSIONS, RESULTS } from "react-native-permissions";
import { Platform, Alert, Linking, AppState, View } from "react-native";
import { StatusBar } from "react-native";
import VersionCheck from "react-native-version-check";

//import Screens
import SideMenuScreen from "./src/views/SideMenu";
import PackageList from "./src/views/BookAPackges";
import TestList from "./src/views/BookATest";
import FacilitesList from "./src/views/Facilites";
import InstrumentScreen from "./src/views/Instruments";
import BookAVisit from "./src/views/BookAVisit";
import Aboutus from "./src/views/Aboutus";
import MyTabs from "./src/views/TabBar";
import { api } from "./src/utils/ApiService/api";
import MyCartView from "./src/views/MyCartView";
import PlaceInquery from "./src/views/PlaceInquery";
import useNetworkStatus from "./src/utils/useNetworkStatus";
import NoInternetScreen from "./src/components/NoInternetScreen";
import UpdateModal from "./src/components/UpdateModal";
import { showAlert } from "./src/utils/CustomAlertPopup";

const Drawer = createDrawerNavigator();
// Create Native Stack Navigators
const TestStack = createNativeStackNavigator();
const PackageStack = createNativeStackNavigator();
const FacilitesStack = createNativeStackNavigator();
const InstrumentStack = createNativeStackNavigator();
const BookAVisitStack = createNativeStackNavigator();
const AboutUsStack = createNativeStackNavigator();

// 🧪 Test Stack
function TestStackNavigator() {
  return (
    <TestStack.Navigator screenOptions={{ headerShown: false }}>
      <TestStack.Screen name="TestList" component={TestList} />
    </TestStack.Navigator>
  );
}

// 📦 Package Stack (Includes Details)
function PackageStackNavigator() {
  return (
    <PackageStack.Navigator screenOptions={{ headerShown: false }}>
      <PackageStack.Screen name="PackageList" component={PackageList} />
    </PackageStack.Navigator>
  );
}

// 🧪 Facilites Stack
function FacilitesStackNavigator() {
  return (
    <FacilitesStack.Navigator screenOptions={{ headerShown: false }}>
      <TestStack.Screen name="FacilitesList" component={FacilitesList} />
    </FacilitesStack.Navigator>
  );
}

// 🧪 Instrument Stack
function InstrumentStackNavigator() {
  return (
    <InstrumentStack.Navigator screenOptions={{ headerShown: false }}>
      <InstrumentStack.Screen name="Instrument" component={InstrumentScreen} />
    </InstrumentStack.Navigator>
  );
}

// 🧪 BookAVisit Stack
function BookAVisitStackNavigator() {
  return (
    <BookAVisitStack.Navigator screenOptions={{ headerShown: false }}>
      <BookAVisitStack.Screen name="BookAVisit" component={BookAVisit} />
    </BookAVisitStack.Navigator>
  );
}
// 🧪 BookAVisit Stack
function AboutUsStackNavigator() {
  return (
    <AboutUsStack.Navigator screenOptions={{ headerShown: false }}>
      <AboutUsStack.Screen name="Aboutus" component={Aboutus} />
    </AboutUsStack.Navigator>
  );
}

const requestPermissions = async () => {
  if (Platform.OS === "ios") {
    const locationStatus = await request(PERMISSIONS.IOS.LOCATION_WHEN_IN_USE);
    const cameraStatus = await request(PERMISSIONS.IOS.CAMERA);
    const photoLibraryStatus = await request(PERMISSIONS.IOS.PHOTO_LIBRARY);

    if (
      locationStatus === RESULTS.GRANTED &&
      cameraStatus === RESULTS.GRANTED &&
      photoLibraryStatus === RESULTS.GRANTED
    ) {
      getCurrentLocation();
      // Alert.alert('Success', 'All permissions granted!');
      console.log("Permitions Allow");
    } else {
      // Alert.alert('Warning', 'Some permissions were denied!');
      console.log("Permitions Issues");
    }
  } else if (Platform.OS === "android") {
    const locationStatus = await request(
      PERMISSIONS.ANDROID.ACCESS_FINE_LOCATION
    );
    const cameraStatus = await request(PERMISSIONS.ANDROID.CAMERA);
    const ImageStatus = await request(
      PERMISSIONS.ANDROID.READ_EXTERNAL_STORAGE
    );

    if (
      locationStatus === RESULTS.GRANTED &&
      cameraStatus === RESULTS.GRANTED &&
      ImageStatus === RESULTS.GRANTED
    ) {
      // Alert.alert('Success', 'All permissions granted!');
      getCurrentLocation();
      console.log("Permitions Allow");
    } else {
      console.log("Permitions locationStatus", locationStatus);
      console.log("Permitions cameraStatus", cameraStatus);
      console.log("Permitions ImageStatus", ImageStatus);
      // Alert.alert('Warning', 'Some permissions were denied!');
    }
  }
};
const getCurrentLocation = () => {
  Geolocation.getCurrentPosition(
    (position) => {
      console.log("Location:", position);
    },
    (error) => {
      console.log("Error:", error);
    },
    {
      enableHighAccuracy: true,
      timeout: 50000,
      maximumAge: 10000,
    }
  );
};

export default function App() {
  const isConnected = useNetworkStatus();

  const appState = useRef(AppState.currentState);

  const [appStateVisible, setAppStateVisible] = useState(AppState.currentState);
  useEffect(() => {
    requestPermissions();
  }, []);
  const StatusBarBackground = ({ backgroundColor }) => {
    const insets = useSafeAreaInsets();

    return (
      <View
        style={{
          height: insets.top,
          backgroundColor: backgroundColor || "red",
        }}
      />
    );
  };
  // Wrapper component to handle offline logic
  const AppContentWithOffline = ({ children }) => {
    if (!isConnected) {
      return <NoInternetScreen />;
    }

    return children;
  };

  const [isUpdateNeeded, setIsUpdateNeeded] = useState(false);

  // useEffect(() => {
  //   const checkForUpdate = async () => {
  //     const updateNeeded = await VersionCheck.needUpdate();
  //     if (updateNeeded?.isNeeded) {
  //       setIsUpdateNeeded(true);
  //     }
  //   };
  //   checkForUpdate();
  // }, []);

  useEffect(() => {
    const checkForUpdate = async () => {
      try {
        const updateNeeded = await VersionCheck.needUpdate();
        if (updateNeeded?.isNeeded) {
          setIsUpdateNeeded(true);
        } else {
          setIsUpdateNeeded(false);
        }
      } catch (error) {
        console.error("Error checking for update:", error);
      }
    };

    checkForUpdate();
  }, []);

  // useEffect(() => {
  //   const subscription = AppState.addEventListener("change", (nextAppState) => {
  //     // console.log("jkhnjkshjsd ::::" ,appState.current)
  //     // console.log("jkhnjkshjsd 2 ::" ,nextAppState)

  //     if (
  //       AppState.currentState.match(/inactive|background/) &&
  //       nextAppState === "active"
  //     ) {
  //       // checkAppVersion();
  //     }
  //     if (nextAppState === "active") {
  //       checkAppVersion();
  //     } else if (nextAppState === "background") {
  //       // checkAppVersion();
  //     }
  //     AppState.currentState = nextAppState;
  //     setAppStateVisible(AppState.currentState);
  //   });

  //   return () => {
  //     subscription.remove();
  //   };
  // });

  // useEffect(() => {
  //   checkAppVersion();
  // }, []);

  // Check for App Version Updates
  const checkAppVersion = async () => {
    try {
      const latestVersion = await VersionCheck.getLatestVersion();
      const currentVersion = await VersionCheck.getCurrentVersion();
      console.log("latestVersion", latestVersion);
      console.log("currentVersion", currentVersion);
      console.log("currentVersion>>", latestVersion > currentVersion);

      if (latestVersion > currentVersion) {
        const updateUrl =
          Platform.OS === "ios"
            ? "https://apps.apple.com/us/app/healthcare-24x7-pathology-lab/id1344409972"
            : "https://apps.apple.com/us/app/healthcare-24x7-pathology-lab/id1344409972"; //Android pending

        Alert.alert(
          "Update Available",
          "A new version of the app is available. Please update to the latest version.",
          [{ text: "Update", onPress: () => Linking.openURL(updateUrl) }]
        );
        console.log("currentVersion", updateUrl);

        // showAlert({
        //   title: 'Update Available!',
        //   message: 'A new version of the app is available. Please update to the latest version.',
        //   onConfirm: () => {
        //     Linking.openURL(updateUrl)
        //   },
        //   yesText: 'UPDATE',
        //   noText: ''
        // })
      }
    } catch (error) {
      console.error("Error checking app version:", error);
    }
  };

  return (
    <SafeAreaProvider
      style={{ height: "100%", backgroundColor: colors.primary }}
    >
      <CartProvider>
        <ConfigProvider>
          <NavigationContainer>
            {isUpdateNeeded ? (
              <UpdateModal
                visible={true}
                onClose={() => {
                  setIsUpdateNeeded(false);
                }}
              />
            ) : (
              <AppContentWithOffline>
                <StatusBar
                  translucent
                  // backgroundColor="transparent"
                  barStyle="light-content"
                />
                {/* <StatusBarBackground backgroundColor={colors.primary} /> */}
                <SafeAreaView style={{ flex: 1 }}>
                  <AppContent />
                </SafeAreaView>
              </AppContentWithOffline>
            )}

            {/* <AppContentWithOffline>
              <SafeAreaView style={{ flex: 1 }}>
                <AppContent />
              </SafeAreaView>
              {isUpdateNeeded && (
                <UpdateModal
                  visible={isUpdateNeeded}
                  onClose={() => setIsUpdateNeeded(false)}
                />
              )}
            </AppContentWithOffline> */}
          </NavigationContainer>
        </ConfigProvider>
      </CartProvider>
    </SafeAreaProvider>
  );
}
// Component that fetches config data and provides it globally
const AppContent = () => {
  const { updateConfig } = useConfig();
  useEffect(() => {
    const fetchConfig = async () => {
      try {
        const response = await api.get("/sysConfig.php");
        if (response.success == true) {
          updateConfig(response.data.data[0]); // Update context with fetched data
        } else {
          console.error("Failed to fetch data");
        }
      } catch (error) {
        console.error("Error fetching data: ", error);
      }
    };

    fetchConfig();
  }, [updateConfig]);

  return (
    <Drawer.Navigator
      drawerContent={(props) => <SideMenuScreen {...props} />}
      screenOptions={{
        drawerStyle: {
          width: 280,
          borderTopRightRadius: 80,
          backgroundColor: colors.primary,
        },
        drawerType: "front",
        headerShown: false,
        drawerPosition: "left",
      }}
    >
      <Drawer.Screen name="HomeDrawer" component={MyTabs} />
      <Drawer.Screen name="BookTest" component={TestStackNavigator} />
      <Drawer.Screen name="BookPackage" component={PackageStackNavigator} />
      <Drawer.Screen name="Facilities" component={FacilitesStackNavigator} />
      <Drawer.Screen name="Instrument" component={InstrumentStackNavigator} />
      <Drawer.Screen name="BookAVisit" component={BookAVisitStackNavigator} />
      <Drawer.Screen name="AboutUs" component={AboutUsStackNavigator} />
      <Drawer.Screen name="MyCartView" component={MyCartView} />
      <Drawer.Screen name="PlaceInquery" component={PlaceInquery} />

      {/* Add other screens */}
    </Drawer.Navigator>
  ); // Your main navigation
};
