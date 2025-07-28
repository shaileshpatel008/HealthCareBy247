import React, { useRef } from 'react';
import { View, Text, Image, TouchableOpacity, SafeAreaView } from 'react-native';
import { WebView } from "react-native-webview";
import common from '../styles/commonStyle';
import styles from '../styles/stylesFacilites';
import images from '../utils/images';
import stylesFonts from '../styles/styleFonts';

const FacilitesList = ({ navigation }) => {
  const webViewRef = useRef(null);

  // JavaScript to disable all pointer events on the page
  const disableClickScript = `
    document.body.style.pointerEvents = 'none';
    true; // Required for Android
  `;

  return (
    <SafeAreaView style={common.container}>
      <View style={styles.background}>
        <View style={common.header}>
          <TouchableOpacity onPress={() => navigation.openDrawer()}>
            <Image source={images.menu} style={styles.headerIcon} />
          </TouchableOpacity>
          <Text style={[styles.headerTitle, stylesFonts.bold]}>Facilities</Text>
          <View style={styles.emptySpace} />
        </View>
        <WebView
          ref={webViewRef}
          style={styles.webview}
          source={{ uri: "https://healthcare24x7.com/hcplab-pages/facilities.html" }}
          javaScriptEnabled={true}
          domStorageEnabled={true}
          scalesPageToFit={true}
          startInLoadingState={true}
          injectedJavaScript={`
            const meta = document.createElement('meta'); 
            meta.setAttribute('name', 'viewport'); 
            meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'); 
            document.getElementsByTagName('head')[0].appendChild(meta);
            
            // Disable all pointer events
            document.body.style.pointerEvents = 'none';
            true;
          `}
          onLoadEnd={() => {
            // Re-inject the script after page loads to ensure it's applied
            webViewRef.current.injectJavaScript(disableClickScript);
          }}
        />
      </View>
    </SafeAreaView>
  );
};

export default FacilitesList;