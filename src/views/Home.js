// import React, { useState, useEffect } from 'react';
// import { ScrollView, View, Text, TouchableOpacity, Image, Dimensions, SafeAreaView, Alert } from 'react-native';
// import { useSharedValue, withTiming } from 'react-native-reanimated';
// import Carousel, { Pagination } from 'react-native-reanimated-carousel';
// import { launchCamera, launchImageLibrary } from 'react-native-image-picker';

// //Files
// import common from '../styles/commonStyle';
// import stylesFonts from '../styles/styleFonts';
// import colors from '../utils/colors';
// import images from '../utils/images';
// import styles from '../styles/styleHome';
// import SubmitPrescriptions from '../views/SubmitPrescriptions';
// import UploadPrescriptionScreen from './UploadPrescriptions';
// import { api } from '../utils/ApiService/api';
// import { useCart } from '../context/CartContext';
// import { BackHandler } from 'react-native';
// import { useFocusEffect } from '@react-navigation/native';
// import PromptBox from '../components/PromptBox';

// const width = Dimensions.get('window').width;

// const HomeScreen = ({ navigation }) => {
//   const [bannerList, setBanner] = useState([]);
//   const [modalVisible, setModalVisible] = useState(false);
//   const [modalSubmit, setModalSubmit] = useState(false);
//   const [imageUri, setImageUri] = useState(null);
//   const { state } = useCart();
//   const [cartCount, setCartCount] = useState(0);
//   const [imageUris, setImageUris] = useState([]);
//   const [exitPromptVisible, setExitPromptVisible] = useState(false);

//   useEffect(() => {
//     setCartCount(state.items.length);
//   }, [state.items]);

//   const imagesData = bannerList.map(obj => ({
//     preview_url: obj.preview_url,
//     param: obj.param,
//   }));

//   useFocusEffect(
//     React.useCallback(() => {
//       const onBackPress = () => {
//         setExitPromptVisible(true); // Show custom prompt
//         return true;
//       };

//       const backHandler = BackHandler.addEventListener("hardwareBackPress", onBackPress);
//       return () => backHandler.remove();
//     }, [])
//   );

//   const fetchBanner = async () => {
//     try {
//       const response = await api.get('/newsletter.php');
//       if (response.success == true) {
//         console.log("Banner List:===========", response.data.data);
//         setBanner(response.data.data);
//       } else {
//         setError('Failed to fetch reports');
//       }
//     } catch (err) {
//       setError(err.message);
//     } finally {
//       setLoading(false);
//     }
//   };

//   // const openCamera = () => {
//   //   const options = { mediaType: 'photo', quality: 0.5, saveToPhotos: true };
//   //   launchCamera(options, (response) => {
//   //     if (response.didCancel) {
//   //       Alert.alert('User cancelled camera');
//   //     } else if (response.errorMessage) {
//   //       Alert.alert('Camera Error:', response.errorMessage);
//   //     } else {
//   //       setImageUris([...imageUris, response.assets[0].uri]);
//   //       setModalSubmit(true);
//   //     }
//   //   });
//   // };

//   const openCamera = (imageUriFromIOS = null) => {
//     if (imageUriFromIOS) {
//       // This was already handled by iOS, no need to open camera again
//       setImageUris((prev) => [...prev, imageUriFromIOS]);
//       setModalSubmit(true);
//       return;
//     }

//     // Only run below for Android
//     if (Platform.OS === 'android') {
//       const options = { mediaType: 'photo', quality: 0.5, saveToPhotos: true };
//       launchCamera(options, (response) => {
//         if (response.didCancel) {
//           Alert.alert('User cancelled camera');
//         } else if (response.errorMessage) {
//           Alert.alert('Camera Error:', response.errorMessage);
//         } else if (response.assets && response.assets[0].uri) {
//           setImageUris((prev) => [...prev, response.assets[0].uri]);
//           setModalSubmit(true);
//         }
//       });
//     }
//   };

//   // 📂 Open Gallery (Multiple Selection)
//   const openGallery = () => {
//     const options = { mediaType: 'photo', quality: 0.5, selectionLimit: 5 };
//     launchImageLibrary(options, (response) => {
//       if (response.didCancel) {
//         Alert.alert('User cancelled gallery');
//       } else if (response.errorMessage) {
//         Alert.alert('Gallery Error:', response.errorMessage);
//       } else {
//         const newImages = response.assets.map(asset => asset.uri);
//         setImageUris([...imageUris, ...newImages]);
//         setModalSubmit(true);
//       }
//     });
//   };

//   const progress = useSharedValue(0);
//   const renderItem = ({ item }) => (
//     <TouchableOpacity
//       onPress={() => {
//         if (item.param === "Y") {
//           navigation.navigate("BookPackage"); // Open Package List
//         }
//       }}
//       activeOpacity={0.8}
//     >
//       <View style={styles.card}>
//         <Image source={{ uri: item.preview_url }} style={styles.image} />
//       </View>
//     </TouchableOpacity>
//   );

//   // Fetch data when component mounts
//   // useEffect(() => {
//   //   fetchBanner();
//   // }, []);

//   useFocusEffect(
//     React.useCallback(() => {
//       fetchBanner();
//     }, [])
//   );

//   return (
//     <SafeAreaView style={common.container}>
//       <View style={styles.background}>
//         {/* Header */}
//         <View style={common.header}>
//           <TouchableOpacity onPress={() => navigation.openDrawer()}>
//             <Image source={images.menu} style={styles.headerIcon} />
//           </TouchableOpacity>
//           <View style={styles.headerTitleGrid}>
//             <View style={[styles.mainHeaderTitle]}>
//               <Text style={[styles.headerTitle, stylesFonts.bold]}>Health Care 24x7 Lab</Text>
//             </View>
//             <View style={[styles.mainHeaderTitle]}>
//               <Text style={[styles.headerSubTitle, stylesFonts.medium]}>Ahmedabad</Text>
//             </View>
//           </View>
//           <TouchableOpacity onPress={() => navigation.navigate('MyCartView')} style={{ position: 'relative' }}>
//             <Image source={images.cart} style={styles.headerIcon} />
//             {cartCount > 0 && (
//               <View style={common.cartBadge}>
//                 <Text style={common.cartBadgeText}>{cartCount}</Text>
//               </View>
//             )}
//           </TouchableOpacity>
//         </View>
//         <ScrollView style={styles.content}>
//           {/* Carousal Slider*/}
//           <View style={styles.carouselView}>
//             <Carousel
//               width={width * 0.9} // Width of each carousel item
//               height={width * 0.51} // Height of each carousel item
//               data={imagesData} // Array of image URLs
//               renderItem={renderItem}
//               loop={true} // Enables infinite scrolling
//               autoPlay={true} // Enables auto-play
//               autoPlayInterval={3000} // Auto-play interval (3 seconds)
//               onProgressChange={(_, absoluteProgress) => {
//                 progress.value = absoluteProgress; // Update progress
//               }}
//             />
//           </View>
//           {/* Paggination Dot*/}
//           <View style={styles.paginationContainer}>
//             <Pagination.Custom
//               progress={progress}
//               data={imagesData}
//               dotStyle={styles.dotStyle}
//               containerStyle={styles.dotContainer}
//               activeDotStyle={styles.activeDotStyle}
//             />
//           </View>
//           {/* Main Grid */}
//           <View style={styles.gridContainer}>
//             <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]} onPress={() => navigation.navigate('BookPackage')} >
//               <Image source={images.homeBookAPakage} style={styles.icon} />
//               <Text style={[styles.gridText, stylesFonts.semibold]}>Book Package</Text>
//             </TouchableOpacity>
//             <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]} onPress={() => navigation.navigate('BookTest')}>
//               <Image source={images.homeBookATest} style={styles.icon} />
//               <Text style={[styles.gridText, stylesFonts.semibold]}>Book Test</Text>
//             </TouchableOpacity>
//             <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]} onPress={() => navigation.navigate('BookAVisit')}>
//               <Image source={images.homeBookVisit} style={styles.icon} />
//               <Text style={[styles.gridText, stylesFonts.semibold]}>Book Visit</Text>
//             </TouchableOpacity>
//             <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]} onPress={() => setModalVisible(true)}>
//               <Image source={images.homeUploadPrescription} style={styles.icon} />
//               <Text style={[styles.gridText, stylesFonts.semibold]}>Upload Prescription</Text>
//             </TouchableOpacity>
//           </View>
//         </ScrollView>
//       </View>
//       <View>
//         <UploadPrescriptionScreen
//           visible={modalVisible}
//           onClose={() => setModalVisible(false)}
//           onGallery={() => {
//             console.log('Gallery Selected');
//             setModalVisible(false);
//             openGallery()
//           }}
//           onCamera={() => {
//             console.log('camera Selected');
//             setModalVisible(false);
//             openCamera()
//           }}
//         />
//       </View>
//       <View>
//         <SubmitPrescriptions
//           visible={modalSubmit}
//           imageUri={imageUris}
//           setImageUri={setImageUris}
//           onSubmit={(message) => {
//             console.log('Submit fourm Selected');
//             setModalSubmit(false);
//             Alert.alert('Healthcare 24x7 Lab', message);
//           }}
//           onClose={() => {
//             setModalSubmit(false);
//           }}
//         />
//       </View>
//       <View>
//         <PromptBox
//           visible={exitPromptVisible}
//           title="Exit Application?"
//           description="Are you sure you want to close the app?"
//           onCancel={() => setExitPromptVisible(false)}
//           onConfirm={() => {
//             setExitPromptVisible(false);
//             BackHandler.exitApp();
//           }}
//         />
//       </View>
//     </SafeAreaView>
//   );
// };

// export default HomeScreen;

import React, { useState, useEffect, useRef, useCallback } from "react";
import {
  ScrollView,
  View,
  Text,
  TouchableOpacity,
  Image,
  Dimensions,
  SafeAreaView,
  Alert,
  Platform,
  PermissionsAndroid,
  StatusBar,
} from "react-native";
import { useSharedValue, withTiming } from "react-native-reanimated";
import Carousel, { Pagination } from "react-native-reanimated-carousel";
import { launchCamera, launchImageLibrary } from "react-native-image-picker";

// Files
import common from "../styles/commonStyle";
import stylesFonts from "../styles/styleFonts";
import colors from "../utils/colors";
import images from "../utils/images";
import styles from "../styles/styleHome";
import SubmitPrescriptions from "../views/SubmitPrescriptions";
import UploadPrescriptionScreen from "./UploadPrescriptions";
import { api } from "../utils/ApiService/api";
import { useCart } from "../context/CartContext";
import { BackHandler } from "react-native";
import { useFocusEffect } from "@react-navigation/native";
import PromptBox from "../components/PromptBox";
import ImagePicker from "react-native-image-crop-picker";

const width = Dimensions.get("window").width;
const height = Dimensions.get("window").height;

const HomeScreen = ({ navigation }) => {
  const [bannerList, setBanner] = useState([]);
  const [modalVisible, setModalVisible] = useState(false);
  const [modalSubmit, setModalSubmit] = useState(false);
  const [imageUri, setImageUri] = useState(null);
  const { state } = useCart();
  const [cartCount, setCartCount] = useState(0);
  const [imageUris, setImageUris] = useState([]);
  const [imageee, setImagesss] = useState([]);
  const [exitPromptVisible, setExitPromptVisible] = useState(false);
  const imageUrisRef = useRef([]);

  useEffect(() => {
    setCartCount(state.items.length);
  }, [state.items]);

  const imagesData = bannerList.map((obj) => ({
    preview_url: obj.preview_url,
    param: obj.param,
  }));

  useFocusEffect(
    React.useCallback(() => {
      const onBackPress = () => {
        setExitPromptVisible(true); // Show custom prompt
        return true;
      };

      const backHandler = BackHandler.addEventListener(
        "hardwareBackPress",
        onBackPress
      );
      return () => backHandler.remove();
    }, [])
  );

  const fetchBanner = async () => {
    try {
      const response = await api.get("/newsletter.php");
      if (response?.success == true) {
        console.log("Banner List:===========", response?.data.data);
        setBanner(response?.data.data);
      } else {
        setError("Failed to fetch reports");
      }
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };
  const requestPermissions = async () => {
    if (Platform.OS === "android") {
      try {
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.CAMERA,
          PermissionsAndroid.PERMISSIONS.READ_EXTERNAL_STORAGE,
          PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
        ]);
        return (
          granted["android.permission.CAMERA"] ===
            PermissionsAndroid.RESULTS.GRANTED &&
          granted["android.permission.READ_EXTERNAL_STORAGE"] ===
            PermissionsAndroid.RESULTS.GRANTED
        );
      } catch (err) {
        console.warn(err);
        return false;
      }
    }
    return true;
  };
  const openCameraIOS = async () => {
    console.log("jkhahdsasd 342 B");
    const hasPermission = await requestPermissions();
    if (!hasPermission) {
      Alert.alert("Permission required");
      return;
    }
    openCamera();
    // ImagePicker.openCamera({
    //   width: 300,
    //   height: 400,
    //   cropping: true,
    // })
    //   .then(image => {
    //     setImage(image);
    //     onCamera(image); // Pass selected image to parent if needed
    //   })
    //   .catch(err => {
    //     if (err.code !== 'E_PICKER_CANCELLED') {
    //       console.log('Camera error:', err);
    //     }
    //   });
  };

  const openCamera2 = async () => {
    console.log("jkhahdsasd cameraaaa");
    const options = {
      mediaType: "photo",
      quality: 0.5,
      saveToPhotos: true,
      presentationStyle: "fullScreen",
    };
    setTimeout(() => {
      launchCamera(options, (response) => {
        if (response?.didCancel) {
          Alert.alert("User cancelled camera");
        } else if (response?.errorMessage) {
          Alert.alert("Camera Error:", response?.errorMessage);
        } else {
          const uri = response?.assets?.[0]?.uri;
          console.log("Camera image URI:", uri);
          console.log("Camera image URI333:", imageUris);
          // setImageUris((prev) => [...prev, uri]); // ✅ use functional update
          setImageUris((prev) => [...prev, uri]); // ✅ use functional update
          console.log("Camera image URI333 11:", imageUris);
          alert("Image captured successfully");
          setImagesss((prev) => [...prev, uri]); // Store the captured image URI
        }
      });
    }, 100);
  };

  const openCamera = async () => {
    try {
      const image = await ImagePicker.openCamera({
        width: 300,
        height: 400,
        cropping: false,
        includeBase64: true,
        useFrontCamera: true,
        mediaType: "photo",
        compressImageQuality: 0.8,
        cropperCircleOverlay: false,
      });

      const uri = image?.path;
      console.log("Captured Image Path:", uri);

      if (uri) {
        // ✅ update state correctly
        setImageUris((prev) => {
          const updated = [...prev, uri];
          console.log("Updated imageUris inside setState:", updated);
          setTimeout(() => {
            console.log("🕒 Delayed check:", updated);
          }, 500);
          return updated;
        });
        setImagesss((prev) => {
          const updated = [...prev, uri];
          console.log("Updated imageUris inside setState:", updated);
          setTimeout(() => {
            console.log("🕒 Delayed check:", updated);
          }, 500);
          return updated;
        });
        console.log("Updated imageUris inside setState 2:", imageUris);

        // ✅ if you're using imageee for tracking modal open, do the same

        // You don't need to setModalSubmit here unless it's not triggered in useEffect
      }
    } catch (error) {
      if (error?.code === "E_NO_CAMERA_PERMISSION") {
        Alert.alert(
          "Camera Permission Needed",
          "To take a photo, please allow camera access in app settings.",
          [
            { text: "Cancel", style: "cancel" },
            {
              text: "Go to Settings",
              onPress: () => Linking.openSettings(),
            },
          ],
          { cancelable: true }
        );
      } else {
        console.log("Unexpected camera error:", error);
      }
    }
  };

  useEffect(() => {
    console.log("🧠 Rendered with imageUris =", imageUris);
  });
  useEffect(() => {
    setTimeout(() => {
      console.log("imageUris updated after sec :", imageUris);
    }, 100);
    console.log("⚡ useEffect ran: imageUris =", JSON.stringify(imageUris));

    console.log("imageUris updated:", imageUris);
    if (imageUris.length > 0) {
      setModalSubmit(true);
    }
  }, [imageUris]);

  useEffect(() => {
    // setimage
    console.log("imageee changed 432=====:", imageee);
    if (imageee.length > 0) {
      setModalSubmit(true);
    }
  }, [imageee]);

  const openGallery = () => {
    const options = {
      mediaType: "photo",
      quality: 0.5,
      selectionLimit: 5,
      presentationStyle: "fullScreen",
    };

    setTimeout(() => {
      launchImageLibrary(options, (response) => {
        if (response?.didCancel) {
          Alert.alert("User cancelled gallery");
        } else if (response?.errorMessage) {
          Alert.alert("Gallery Error:", response?.errorMessage);
        } else {
          const newImages = response?.assets?.map((asset) => asset.uri) || [];
          console.log("Selected gallery images:", newImages);
          setImageUris((prev) => [...prev, ...newImages]); // ✅ use functional update
        }
      });
    }, 100);
  };

  useEffect(() => {
    console.log("imageUris changed=====:", imageUris);
    if (imageUris.length > 0) {
      setModalSubmit(true);
    }
  }, [imageUris]);

  const progress = useSharedValue(0);
  const renderItem = ({ item }) => (
    <TouchableOpacity
      onPress={() => {
        if (item.param === "Y") {
          navigation.navigate("BookPackage"); // Open Package List
        }
      }}
      activeOpacity={0.8}
    >
      <View style={styles.card}>
        <Image source={{ uri: item.preview_url }} style={styles.image} />
      </View>
    </TouchableOpacity>
  );

  useFocusEffect(
    React.useCallback(() => {
      fetchBanner();
    }, [])
  );

  return (
    <SafeAreaView style={common.container}>
      <View style={styles.background}>
        {/* Header */}
        <View style={common.header}>
          <TouchableOpacity onPress={() => navigation.openDrawer()}>
            <Image source={images.menu} style={styles.headerIcon} />
          </TouchableOpacity>
          <View style={styles.headerTitleGrid}>
            <View style={[styles.mainHeaderTitle]}>
              <Text style={[styles.headerTitle, stylesFonts.bold]}>
                Health Care 24x7 Lab
              </Text>
            </View>
            <View style={[styles.mainHeaderTitle]}>
              <Text style={[styles.headerSubTitle, stylesFonts.medium]}>
                Ahmedabad
              </Text>
            </View>
          </View>
          <TouchableOpacity
            onPress={() => navigation.navigate("MyCartView")}
            style={{ position: "relative" }}
          >
            <Image source={images.cart} style={styles.headerIcon} />
            {cartCount > 0 && (
              <View style={common.cartBadge}>
                <Text style={common.cartBadgeText}>{cartCount}</Text>
              </View>
            )}
          </TouchableOpacity>
        </View>
        <ScrollView style={styles.content}>
          {/* Carousel Slider */}
          <View style={styles.carouselView}>
            <Carousel
              width={width * 0.9}
              height={height / 3.8}
              data={imagesData}
              renderItem={renderItem}
              loop={true}
              autoPlay={true}
              autoPlayInterval={3000}
              onProgressChange={(_, absoluteProgress) => {
                progress.value = absoluteProgress;
              }}
            />
          </View>
          {/* Pagination Dots */}
          <View style={styles.paginationContainer}>
            <Pagination.Custom
              progress={progress}
              data={imagesData}
              dotStyle={styles.dotStyle}
              containerStyle={styles.dotContainer}
              activeDotStyle={styles.activeDotStyle}
            />
          </View>
          {/* Main Grid */}
          <View style={styles.gridContainer}>
            <TouchableOpacity
              style={[styles.gridItem, { backgroundColor: colors.white }]}
              onPress={() => navigation.navigate("BookPackage")}
            >
              <Image source={images.homeBookAPakage} style={styles.icon} />
              <Text style={[styles.gridText, stylesFonts.semibold]}>
                Book Package
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.gridItem, { backgroundColor: colors.white }]}
              onPress={() => navigation.navigate("BookTest")}
            >
              <Image source={images.homeBookATest} style={styles.icon} />
              <Text style={[styles.gridText, stylesFonts.semibold]}>
                Book Test
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.gridItem, { backgroundColor: colors.white }]}
              onPress={() => navigation.navigate("BookAVisit")}
            >
              <Image source={images.homeBookVisit} style={styles.icon} />
              <Text style={[styles.gridText, stylesFonts.semibold]}>
                Book Visit
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={[styles.gridItem, { backgroundColor: colors.white }]}
              onPress={() => setModalVisible(true)}
            >
              <Image
                source={images.homeUploadPrescription}
                style={styles.icon}
              />
              <Text style={[styles.gridText, stylesFonts.semibold]}>
                Upload Prescription
              </Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </View>
      <View>
        <UploadPrescriptionScreen
          visible={modalVisible}
          onClose={() => setModalVisible(false)}
          onGallery={() => {
            console.log("Gallery Selected");
            openGallery();
            setModalVisible(false);
          }}
          onCamera={() => {
            console.log("jkhahdsasd 510 B");
            Platform.OS == "ios" ? openCameraIOS() : openCamera();
            setTimeout(() => {
              setModalVisible(false);
            }, 100);
          }}
        />
      </View>
      <View>
        <SubmitPrescriptions
          visible={modalSubmit}
          imageUri={imageUris}
          setImageUri={setImageUris}
          onSubmit={(message) => {
            console.log("Submit form Selected");
            setModalSubmit(false);
            Alert.alert("Healthcare 24x7 Lab", message);
          }}
          onClose={() => {
            setModalSubmit(false);
          }}
          onReOpen={() => {
            setModalSubmit(true);
          }}
        />
      </View>
      <View>
        <PromptBox
          visible={exitPromptVisible}
          title="Exit Application?"
          description="Are you sure you want to close the app?"
          onCancel={() => setExitPromptVisible(false)}
          onConfirm={() => {
            setExitPromptVisible(false);
            BackHandler.exitApp();
          }}
        />
      </View>
    </SafeAreaView>
  );
};

export default HomeScreen;
