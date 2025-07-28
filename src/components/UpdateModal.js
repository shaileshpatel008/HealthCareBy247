// src/components/UpdateModal.js
import React from "react";
import {
  Modal,
  View,
  Text,
  TouchableOpacity,
  Linking,
  Platform,
  StyleSheet,
} from "react-native";
import colors from "../utils/colors";

const UpdateModal = ({ visible, onClose }) => {
  const updateUrl =
    Platform.OS === "ios"
      ? "https://apps.apple.com/us/app/healthcare-24x7-pathology-lab/id1344409972"
      : "https://play.google.com/store/apps/details?id=com.healthcarelab"; // replace with actual Android package link

  return (
    <Modal visible={visible} transparent animationType="slide">
      <View style={styles.modalContainer}>
        <View style={styles.modalContent}>
          <Text style={styles.title}>Update Available</Text>
          <Text style={styles.message}>
            A new version of the app is available. Please update to continue.
          </Text>
          <TouchableOpacity
            style={styles.updateButton}
            onPress={() => Linking.openURL(updateUrl)}
          >
            <Text style={styles.updateText}>UPDATE NOW</Text>
          </TouchableOpacity>
        </View>
      </View>
    </Modal>
  );
};

export default UpdateModal;

const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    backgroundColor: "rgba(0,0,0,0.7)",
    justifyContent: "center",
    alignItems: "center",
  },
  modalContent: {
    width: "80%",
    backgroundColor: "#fff",
    borderRadius: 12,
    padding: 20,
    alignItems: "center",
  },
  title: {
    fontWeight: "bold",
    fontSize: 18,
    marginBottom: 10,
  },
  message: {
    fontSize: 16,
    textAlign: "center",
    marginBottom: 20,
  },
  updateButton: {
    // backgroundColor: "#007AFF",
    backgroundColor: colors.primary,
    borderRadius: 8,
    paddingVertical: 10,
    paddingHorizontal: 20,
  },
  updateText: {
    color: "#fff",
    fontWeight: "bold",
  },
});

// import React from 'react';
// import {
//     Modal as RNModal,
//     View,
//     Text,
//     TouchableOpacity,
//     Linking,
//     Image,
//     Platform
// } from 'react-native';
// import images from '../utils/images';
// import styles from '../styles/styleUpdateModal';

// const UpdateModal = ({ visible, onClose }) => {
//     const isIOS = Platform.OS === 'ios';

//     const storeURL = isIOS
//         ? 'https://apps.apple.com/app/' //Appstore link
//         : 'https://play.google.com/store/apps/details?id=com.sangitkalakendra&hl=en-US'; //Playstore link

//     const storeName = isIOS ? 'App Store' : 'Google Play';
//     const storeIcon = isIOS ? images.appStoreIcon : images.googlePlay;

//     return (
//         <RNModal
//             visible={visible}
//             transparent={true}
//             animationType="fade"
//             onRequestClose={onClose}
//         >
//             <View style={styles.modalOverlay}>
//                 <View style={styles.modalContainer}>
//                     {/* Store Header */}
//                     <View style={styles.header}>
//                         <View style={styles.headerLeft}>
//                             <Image source={storeIcon} style={styles.googlePlayIcon} />
//                             <Text style={styles.googlePlayText}>{storeName}</Text>
//                         </View>
//                         <TouchableOpacity onPress={onClose}>
//                             <Image source={images.closeIcon} style={styles.closeIcon} />
//                         </TouchableOpacity>
//                     </View>

//                     <Text style={styles.title}>Update available</Text>
//                     <Text style={styles.description}>
//                         To use this app, download the latest version. You can keep using this app while downloading the update.
//                     </Text>

//                     <View style={styles.appInfo}>
//                         <Image source={images.logo} style={styles.appLogo} />
//                         <View>
//                             <Text style={styles.appName}>Health Care Lab</Text>
//                             <Text style={styles.appRated}>Rated for 3+</Text>
//                         </View>
//                     </View>

//                     <View style={styles.whatsNewRow}>
//                         <Text style={styles.whatsNewTitle}>What's new</Text>
//                         <Image source={images.downArrow} style={styles.arrowIcon} />
//                     </View>
//                     <Text style={styles.lastUpdatedText}>Last updated Apr 11, 2025</Text>

//                     <View style={styles.buttonContainer}>
//                         <TouchableOpacity
//                             onPress={() => Linking.openURL(storeURL)}
//                             style={styles.learnMoreButton}
//                         >
//                             <Text style={styles.learnMoreText}>Learn more</Text>
//                         </TouchableOpacity>

//                         <TouchableOpacity
//                             onPress={() => Linking.openURL(storeURL)}
//                             style={styles.updateButton}
//                         >
//                             <Text style={styles.updateButtonText}>Update</Text>
//                         </TouchableOpacity>
//                     </View>
//                 </View>
//             </View>
//         </RNModal>
//     );
// };

// export default UpdateModal;
