import React, { useRef } from 'react';
import { View, Text, Image, TouchableOpacity, SafeAreaView } from 'react-native';
import { WebView } from "react-native-webview";
import images from '../utils/images';
import common from '../styles/commonStyle';
import style from '../styles/styleInstrument';
import stylesFonts from '../styles/styleFonts';

const InstrumentScreen = ({ navigation }) => {
  const webViewRef = useRef(null);

  return (
    <SafeAreaView style={common.container}>
      <View style={style.background}>
        <View style={common.header}>
          <TouchableOpacity onPress={() => navigation.openDrawer()}>
            <Image source={images.menu} style={style.headerIcon} />
          </TouchableOpacity>
          <Text style={[style.headerTitle, stylesFonts.bold]}>Instrument</Text>
          <View style={style.emptySpace} />
        </View>
        <WebView
          ref={webViewRef}
          style={style.webview}
          source={{ uri: "https://healthcare24x7.com/hcplab-pages/Instrument.html" }}
          javaScriptEnabled={true}
          domStorageEnabled={true}
          scalesPageToFit={false} // Disable auto-fitting to allow manual zoom
          startInLoadingState={true}
          injectedJavaScript={`const meta = document.createElement('meta'); 
          meta.setAttribute('name', 'viewport'); 
          meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=3, user-scalable=yes'); 
          document.getElementsByTagName('head')[0].appendChild(meta);`}
          setBuiltInZoomControls={true} // Enables zoom controls on Android
          setDisplayZoomControls={false} // Hides zoom buttons (Android)
        />
      </View>
    </SafeAreaView>
  );
};

export default InstrumentScreen;