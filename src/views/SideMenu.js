import React from "react";
import { CommonActions } from "@react-navigation/native";
import {
  View,
  Text,
  Image,
  TouchableOpacity,
  Linking,
  KeyboardAvoidingView,
  Platform,
} from "react-native";
import { DrawerContentScrollView } from "@react-navigation/drawer";
import { SafeAreaView } from "react-native-safe-area-context";
import images from "../utils/images";
import style from "../styles/stylesSideMenuScreen";
import styleFont from "../styles/styleFonts";
import { useMenuViewModel } from "../viewmodels/MenuViewModel";
import { useConfig } from "../context/ConfigContext"; // Import the custom hook
import { Screen } from "react-native-screens";
import colors from "../utils/colors";

const SideMenuScreen = (props) => {
  const { menuData } = useMenuViewModel();
  const { config } = useConfig();

  const handleEmailPress = (email) => {
    Linking.openURL(`mailto:${email}`);
  };
  const handleWebsitePress = (url) => {
    Linking.openURL(url);
  };

  return (
    <View style={{ flex: 1 }}>
      {/* <KeyboardAvoidingView
      style={{flex:1}}
      behavior={Platform.OS == 'ios' ? 'padding' : 'padding'}> */}
      <View style={style.container}>
        {/* Header Section */}
        <View style={style.header}>
          <View style={[style.headerSections]}>
            <Image source={images.logo} style={style.logo} />
            <TouchableOpacity
              style={style.menuItem}
              onPress={() => props.navigation.closeDrawer()}
            >
              <Image source={images.menuClose} size={24} style={[style.icon]} />
            </TouchableOpacity>
          </View>
          <TouchableOpacity
            onPress={() => handleWebsitePress(config.websitename)}
          >
            <Text style={[style.labName, styleFont.semibold]}>
              Healthcare 24x7 Lab
            </Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={() => handleEmailPress(config.Email)}>
            <Text style={[style.email, styleFont.semibold]}>
              {config.Email}
            </Text>
          </TouchableOpacity>
        </View>

        <View style={style.background}>
          <DrawerContentScrollView
            {...props}
            contentContainerStyle={style.sideMenuDrawerView}
          >
            {/* Menu Items */}
            <View style={style.menuItems}>
              {menuData.map((item, index) => (
                <View key={index} style={style.viewItem}>
                  <TouchableOpacity
                    style={style.menuItem}
                    onPress={() => {
                      if (item.route === "ContactUs") {
                        console.log("Navigating to ContactUs Screen");
                        props.navigation.dispatch(
                          CommonActions.navigate({
                            name: "HomeDrawer",
                            params: {
                              screen: "ContactUs",
                            },
                          })
                        );
                      } else if (item.route === "Home") {
                        props.navigation.dispatch(
                          CommonActions.navigate({
                            name: "HomeDrawer",
                            params: {
                              screen: "Home",
                            },
                          })
                        );
                      } else {
                        console.log(`Navigating to ${item.route}`);
                        props.navigation.navigate(item.route);
                      }
                    }}
                  >
                    <Image source={item.icon} size={20} style={style.icon} />
                    <Text style={style.menuText}>{item.label}</Text>
                  </TouchableOpacity>
                </View>
              ))}
            </View>
          </DrawerContentScrollView>
        </View>
      </View>
      {/* </KeyboardAvoidingView> */}
    </View>
  );
};

export default SideMenuScreen;
