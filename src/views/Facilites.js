import React, { useRef } from 'react';
import { View, Text, Image,TouchableOpacity,SafeAreaView } from 'react-native';
import { WebView } from "react-native-webview";
import common from '../styles/commonStyle';
import styles from '../styles/stylesFacilites';
import images from '../utils/images';

const FacilitesList = ({ navigation }) => {
  const webViewRef = useRef(null);

  return (
    <SafeAreaView style={common.container}>
    <View style={styles.background}>
        <View style={common.header}>
            <TouchableOpacity  onPress={() => navigation.openDrawer()}>
            <Image source={images.menu} style={styles.headerIcon} />
            </TouchableOpacity>
            <Text style={styles.headerTitle}>Facilities</Text>
            <View style={styles.emptySpace} />
            </View>
            <WebView 
                ref={webViewRef} 
                style={styles.webview} 
                source={{ uri: "https://healthcare24x7.com/hcplab-pages/facilities.html" } }
                javaScriptEnabled={true}
                domStorageEnabled={true}
                scalesPageToFit={true} // Ensures content fits screen
                startInLoadingState={true}
                injectedJavaScript={`const meta = document.createElement('meta'); 
                  meta.setAttribute('name', 'viewport'); 
                  meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'); 
                  document.getElementsByTagName('head')[0].appendChild(meta);`}
             />
       </View>
    </SafeAreaView>
  );
};

export default FacilitesList;