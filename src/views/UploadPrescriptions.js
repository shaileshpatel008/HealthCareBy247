// import React, { useState } from 'react';
// import { View, Text, TouchableOpacity, Platform, Alert, PermissionsAndroid } from 'react-native';
// import { Modal as RNModal } from 'react-native';
// import styles from '../styles/stylesUploadPrescriptions';
// import ImagePicker from 'react-native-image-crop-picker';

// const UploadPrescriptionScreen = ({ visible, onClose, onGallery, onCamera }) => {
//   const [image, setImage] = useState(null);

//   const requestPermissions = async () => {
//     if (Platform.OS === 'android') {
//       try {
//         const granted = await PermissionsAndroid.requestMultiple([
//           PermissionsAndroid.PERMISSIONS.CAMERA,
//           PermissionsAndroid.PERMISSIONS.READ_EXTERNAL_STORAGE,
//           PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
//         ]);
//         return (
//           granted['android.permission.CAMERA'] === PermissionsAndroid.RESULTS.GRANTED &&
//           granted['android.permission.READ_EXTERNAL_STORAGE'] === PermissionsAndroid.RESULTS.GRANTED
//         );
//       } catch (err) {
//         console.warn(err);
//         return false;
//       }
//     }
//     return true;
//   };

//   const openCameraIOS = async () => {
//     const hasPermission = await requestPermissions();
//     if (!hasPermission) {
//       Alert.alert('Permission required');
//       return;
//     }

//     ImagePicker.openCamera({
//       width: 300,
//       height: 400,
//       cropping: true,
//     })
//       .then(image => {
//         setImage(image);
//         // Pass the image URI to the parent to update imageUris and open SubmitPrescriptions modal
//         onCamera(image.path); // Use image.path for the URI
//       })
//       .catch(err => {
//         if (err.code !== 'E_PICKER_CANCELLED') {
//           console.log('Camera error:', err);
//         }
//       });
//   };

//   return (
//     <RNModal
//       visible={visible}
//       transparent={true}
//       animationType="slide"
//       onRequestClose={onClose}
//     >
//       <View style={[styles.modalContainer, { backgroundColor: 'rgba(0, 0, 0, 0.4)' }]}>
//         <View style={styles.modalContent}>
//           <Text style={styles.modalTitle}>Healthcare 24x7 Lab</Text>
//           <Text style={styles.modalSubtitle}>Select Photo Option</Text>

//           {/* 📂 Choose From Gallery */}
//           <TouchableOpacity style={styles.button} onPress={onGallery}>
//             <Text style={styles.buttonText}>Choose From Photo Gallery</Text>
//           </TouchableOpacity>

//           {/* 📷 Take Photo */}
//           <TouchableOpacity
//             style={styles.button}
//             onPress={() => {
//               if (Platform.OS === 'ios') {
//                 openCameraIOS(); // iOS-specific logic
//               }
//               // else {
//               //   onCamera(); // Android uses old logic passed as prop
//               // }
//             }}
//           >
//             <Text style={styles.buttonText}>Take Photo</Text>
//           </TouchableOpacity>

//           {/* ❌ Cancel */}
//           <TouchableOpacity style={[styles.button, styles.cancelButton]} onPress={onClose}>
//             <Text style={styles.buttonText}>Cancel</Text>
//           </TouchableOpacity>
//         </View>
//       </View>
//     </RNModal>
//   );
// };

// export default UploadPrescriptionScreen;

import React, { useState } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  Platform,
  Alert,
  PermissionsAndroid,
} from "react-native";
import { Modal as RNModal } from "react-native";
import styles from "../styles/stylesUploadPrescriptions";
import ImagePicker from "react-native-image-crop-picker";

const UploadPrescriptionScreen = ({
  visible,
  onClose,
  onGallery,
  onCamera,
}) => {
  const [image, setImage] = useState(null);

  // const requestPermissions = async () => {
  //   console.log("requestPermissions called");
  //   if (Platform.OS === "android") {
  //     try {
  //       const granted = await PermissionsAndroid.requestMultiple([
  //         PermissionsAndroid.PERMISSIONS.CAMERA,
  //         PermissionsAndroid.PERMISSIONS.READ_EXTERNAL_STORAGE,
  //         PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
  //       ]);
  //       return (
  //         console.log("requestpermission 117", granted),
  //         granted["android.permission.CAMERA"] ===
  //           PermissionsAndroid.RESULTS.GRANTED &&
  //           granted["android.permission.READ_EXTERNAL_STORAGE"] ===
  //             PermissionsAndroid.RESULTS.GRANTED
  //       );
  //     } catch (err) {
  //       console.warn(err);
  //       return false;
  //     }
  //   }
  //   return true;
  // };
  const requestPermissions = async () => {
    if (Platform.OS === "android") {
      try {
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.CAMERA,
          PermissionsAndroid.PERMISSIONS.READ_MEDIA_IMAGES, // Android 13+
          PermissionsAndroid.PERMISSIONS.READ_EXTERNAL_STORAGE, // Older versions
        ]);

        return (
          granted[PermissionsAndroid.PERMISSIONS.CAMERA] ===
            PermissionsAndroid.RESULTS.GRANTED &&
          (granted[PermissionsAndroid.PERMISSIONS.READ_MEDIA_IMAGES] ===
            PermissionsAndroid.RESULTS.GRANTED ||
            granted[PermissionsAndroid.PERMISSIONS.READ_EXTERNAL_STORAGE] ===
              PermissionsAndroid.RESULTS.GRANTED)
        );
      } catch (err) {
        console.warn(err);
        return false;
      }
    }
    return true; // iOS automatically handles permissions
  };
  const openCameraIOS = async () => {
    const hasPermission = await requestPermissions();
    if (!hasPermission) {
      Alert.alert("Permission required");
      return;
    }

    ImagePicker.openCamera({
      width: 300,
      height: 400,
      cropping: true,
    })
      .then((image) => {
        setImage(image);
        onCamera(image); // Pass selected image to parent if needed
      })
      .catch((err) => {
        if (err.code !== "E_PICKER_CANCELLED") {
          console.log("Camera error:", err);
        }
      });
  };

  return (
    <RNModal
      visible={visible}
      transparent={true}
      animationType="slide"
      onRequestClose={onClose}
    >
      <View
        style={[
          styles.modalContainer,
          { backgroundColor: "rgba(0, 0, 0, 0.4)" },
        ]}
      >
        <View style={styles.modalContent}>
          <Text style={styles.modalTitle}>Healthcare 24x7 Lab</Text>
          <Text style={styles.modalSubtitle}>Select Photo Option</Text>

          {/* 📂 Choose From Gallery */}
          <TouchableOpacity style={styles.button} onPress={onGallery}>
            <Text style={styles.buttonText}>Choose From Photo Gallery</Text>
          </TouchableOpacity>

          {/* 📷 Take Photo */}
          <TouchableOpacity
            style={styles.button}
            onPress={() => {
              if (Platform.OS === "ios") {
                // openCameraIOS(); // iOS-specific logic
                console.log("jkhahdsasd 173");
                onCamera();
              } else {
                onCamera(); // Android uses old logic passed as prop
              }
            }}
          >
            <Text style={styles.buttonText}>Take Photo</Text>
          </TouchableOpacity>

          {/* ❌ Cancel */}
          <TouchableOpacity
            style={[styles.button, styles.cancelButton]}
            onPress={onClose}
          >
            <Text style={styles.buttonText}>Cancel</Text>
          </TouchableOpacity>
        </View>
      </View>
    </RNModal>
  );
};

export default UploadPrescriptionScreen;
