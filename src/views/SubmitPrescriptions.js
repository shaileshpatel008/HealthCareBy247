import React, { useEffect, useState } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  Image,
  TextInput,
  ActivityIndicator,
  ScrollView,
  PermissionsAndroid,
  Platform,
} from "react-native";
import styles from "../styles/stylesSubmitPrescriptions";
import stylesFonts from "../styles/styleFonts";
import colors from "../utils/colors";
import UploadPrescriptionScreen from "./UploadPrescriptions";
import { launchCamera, launchImageLibrary } from "react-native-image-picker";
import images from "../utils/images";
import { Alert, Modal as RNModal } from "react-native"; // Use RNModal consistently
import ImagePicker from "react-native-image-crop-picker";
import { PERMISSIONS, RESULTS } from "react-native-permissions";
const SubmitPrescriptions = ({
  visible,
  imageUri,
  setImageUri,
  onSubmit,
  onClose,
  onReOpen,
}) => {
  const [form, setForm] = useState({
    name: "",
    mobileNumber: "",
    errors: {},
    isLoading: false,
  });

  const [imageUris, setImageUris] = useState([]);
  const [fullImageUri, setFullImageUri] = useState(null);
  const [modalVisible, setModalVisible] = useState(false);

  useEffect(() => {
    if (imageUri) {
      setImageUris(Array.isArray(imageUri) ? imageUri : [imageUri]);
    }
  }, [imageUri]);

  const validateInputs = () => {
    let errors = {};

    if (!form.name.trim()) {
      errors.name = "Name is required";
    }

    if (!form.mobileNumber.trim()) {
      errors.mobileNumber = "Mobile number is required";
    } else if (!/^\d{10}$/.test(form.mobileNumber)) {
      errors.mobileNumber = "Enter a valid 10-digit mobile number";
    }

    if (imageUris.length === 0) {
      errors.image = "Prescription image is required";
    }

    setForm((prevForm) => ({ ...prevForm, errors }));
    return Object.keys(errors).length === 0;
  };
  const requestPermissions = async () => {
    console.log("jkhahdsasd 342 B1");
    if (Platform.OS === "android") {
      try {
        const granted = await PermissionsAndroid.requestMultiple([
          PermissionsAndroid.PERMISSIONS.CAMERA,
          PermissionsAndroid.PERMISSIONS.READ_EXTERNAL_STORAGE,
          PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE,
        ]);
        return (
          console.log("jkhahdsasd 342 B2", granted),
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
  const openCamera = async () => {
    // const permission = Platform.OS === 'ios'
    //   ? PERMISSIONS.IOS.CAMERA
    //   : PERMISSIONS.ANDROID.CAMERA;

    //   console.log("jkchd",permission);
    // const result = await check(permission);
    // let granted = result === RESULTS.GRANTED;

    // if (!granted) {
    //   const reqResult = await request(permission);
    //   granted = reqResult === RESULTS.GRANTED;
    // }

    // if (!granted) {
    //   Alert.alert(
    //     'Permission Required',
    //     'Camera access is needed to take a photo.',
    //     [{ text: 'OK' }],
    //   );
    //   return;
    // }
    console.log("jkhahdsasd 342 B");
    const hasPermission = await requestPermissions();
    if (!hasPermission) {
      Alert.alert("Permission required");
      return;
    }
    console.log("jkhahdsasd 342 B 1111");
    const options = {
      mediaType: "photo",
      quality: 0.5,
      saveToPhotos: true,
      presentationStyle: "fullScreen",
    };
    console.log("jkhahdsasd 342 B 1112221");
    setTimeout(() => {
      launchCamera(options, (response) => {
        if (response?.didCancel) {
          Alert.alert("User cancelled camera");
        } else if (response?.errorMessage) {
          Alert.alert("Camera Error:", response?.errorMessage);
        } else {
          setImageUris([...imageUris, response?.assets[0].uri]);
          onReOpen();
        }
      });
    }, 100);
    // Open camera if permission is granted
    // ImagePicker.openCamera({
    //   width: 800,
    //   height: 800,
    //   cropping: false,
    //   compressImageQuality: 0.5,
    // })
    //   .then(image => {
    //     setImageUris(prev => [...prev, image.path]);
    //   })
    //   .catch(err => {
    //     if (err.code !== 'E_PICKER_CANCELLED') {
    //       Alert.alert('Camera Error', err.message || 'Failed to open camera');
    //     }
    //   });
  };

  const openGallery = () => {
    const options = {
      mediaType: "photo",
      quality: 0.5,
      selectionLimit: 5,
      presentationStyle: "fullScreen",
    };
    console.log("jojjsi 399111111");
    setTimeout(() => {
      launchImageLibrary(options, (response) => {
        console.log("jojjsi 4001111", response);
        console.log("jojjsi 4012222", options);
        if (response.didCancel) {
          Alert.alert("User cancelled gallery");
        } else if (response.errorMessage) {
          Alert.alert("Gallery Error:", response.errorMessage);
        } else {
          const newImages = response.assets.map((asset) => asset.uri);
          setImageUris([...imageUris, ...newImages]);
          onReOpen();
        }
      });
    }, 100); // Delay lets iOS fully settle any UI transitions
    // return
    //   console.log("faleytbhjsd")
    //   setTimeout(() => {
    //     console.log("faleytbhjsd11111")
    //     ImagePicker.openPicker({
    //       multiple: true,
    //       cropping: false,
    //       compressImageQuality: 0.5,
    //       mediaType: 'photo',
    //     })
    //     .then(images => {
    //       console.log("faleytbhjsd222")
    //       const uris = images.map(img => img.path);
    //       setImageUris(prev => [...prev, ...uris]);
    //     })
    //     .catch(err => {
    //       console.log("faleytbhjsd333333")
    //       if (err.code !== 'E_PICKER_CANCELLED') Alert.alert('Gallery Error', err.message);
    //     });
    //   }, 10);
  };
  const uploadImage = async () => {
    if (!validateInputs()) return;

    setForm((prevForm) => ({ ...prevForm, isLoading: true }));
    const timestamp = new Date().getTime();
    const formData = new FormData();
    formData.append("MobileNo", form.mobileNumber);
    formData.append("Name", form.name);

    imageUris.forEach((uri, index) => {
      formData.append(`Prescription[${index}]`, {
        uri: uri,
        type: "image/jpeg",
        name: `image_${timestamp}_${index}.jpg`,
      });
    });

    try {
      let response = await fetch(
        "https://healthcare24x7.com/api/onlyPrescription.php",
        {
          method: "POST",
          body: formData,
          headers: {
            "Content-Type": "multipart/form-data",
            Accept: "application/json",
          },
        }
      );

      await response.json();
      clearData();
      onSubmit(
        "Your prescription submitted successfully. We will get back to you soon."
      );
    } catch (error) {
      onSubmit("Prescription submission failed");
    } finally {
      setForm((prevForm) => ({ ...prevForm, isLoading: false }));
    }
  };

  const removeImage = (index) => {
    console.log("Image desc fghfghhfgh  : ", imageUris, " ; index :", index);
    // setImageUris((prev) => prev.filter((_, i) => i !== index));
    setImageUris((prev) => {
      const updated = [...prev];
      updated.splice(index, 1); // removes at index
      return updated;
    });
  };

  const viewFullImage = (uri) => {
    setFullImageUri(uri);
  };

  const clearData = () => {
    setForm({
      name: "",
      mobileNumber: "",
      errors: {},
      isLoading: false,
    });
    setImageUris([]);
    setImageUri([]);
  };
  // console.log("imageuris====--------------========", imageUris);

  return (
    <>
      <RNModal
        visible={visible}
        transparent={true}
        animationType="slide"
        onRequestClose={onClose}
      >
        <View style={styles.modalContainer}>
          <View style={styles.modalContent}>
            {imageUris.length === 0 ? (
              <TouchableOpacity
                style={styles.buttonUpload}
                onPress={() => {
                  onClose();
                  setModalVisible(true);
                }}
              >
                <Image source={images.upload} style={styles.icon} />
                <Text style={[styles.buttonText, stylesFonts.semibold]}>
                  Upload Prescription
                </Text>
              </TouchableOpacity>
            ) : (
              <ScrollView horizontal style={styles.imagePreviewContainer}>
                {imageUris.map((uri, index) => (
                  <View key={index} style={styles.imageContainer}>
                    <TouchableOpacity onPress={() => viewFullImage(uri)}>
                      <Image source={{ uri }} style={styles.imagePreview} />
                    </TouchableOpacity>
                    <TouchableOpacity
                      style={styles.deleteButton}
                      onPress={() => removeImage(index)}
                    >
                      <Text style={styles.deleteText}>X</Text>
                    </TouchableOpacity>
                  </View>
                ))}
                {imageUris.length > 0 && (
                  <TouchableOpacity
                    style={styles.addMoreButton}
                    onPress={() => {
                      console.log("testt222================");
                      console.log("testt================");
                      onClose();
                      setModalVisible(true);
                    }}
                  >
                    <Text style={styles.addMoreText}>+</Text>
                  </TouchableOpacity>
                )}
              </ScrollView>
            )}
            {form.errors.image && (
              <Text style={styles.errorText}>{form.errors.image}</Text>
            )}
            {form.errors.image && (
              <Text style={styles.errorText}>{form.errors.image}</Text>
            )}

            {/* Full Image Modal */}
            <RNModal
              visible={!!fullImageUri}
              transparent={true}
              animationType="fade"
              onRequestClose={() => setFullImageUri(null)}
            >
              <View style={styles.fullImageModal}>
                <TouchableOpacity
                  style={styles.closeModal}
                  onPress={() => setFullImageUri(null)}
                >
                  <Text style={styles.deleteText}>X</Text>
                </TouchableOpacity>
                <Image
                  source={{ uri: fullImageUri }}
                  style={styles.fullImage}
                />
              </View>
            </RNModal>

            <View style={[styles.sectionView, styles.columnStyle]}>
              <Text style={[stylesFonts.semibold, styles.filedText]}>
                Name*
              </Text>
              <TextInput
                style={styles.textFiled}
                placeholder="Enter Your Name"
                value={form.name}
                onChangeText={(text) =>
                  setForm((prevForm) => ({
                    ...prevForm,
                    name: text,
                    errors: { ...prevForm.errors, name: "" },
                  }))
                }
              />
              {form.errors.name && (
                <Text style={styles.errorText}>{form.errors.name}</Text>
              )}
            </View>

            <View style={[styles.sectionView, styles.columnStyle]}>
              <Text style={[stylesFonts.semibold, styles.filedText]}>
                Mobile Number*
              </Text>
              <TextInput
                style={styles.textFiled}
                placeholder="Enter Your Mobile Number"
                value={form.mobileNumber}
                onChangeText={(text) =>
                  setForm((prevForm) => ({
                    ...prevForm,
                    mobileNumber: text,
                    errors: { ...prevForm.errors, mobileNumber: "" },
                  }))
                }
                keyboardType="numeric"
                maxLength={10}
              />
              {form.errors.mobileNumber && (
                <Text style={styles.errorText}>{form.errors.mobileNumber}</Text>
              )}
            </View>

            <TouchableOpacity
              style={[styles.button, styles.submitButton]}
              onPress={uploadImage}
            >
              {form.isLoading ? (
                <ActivityIndicator size="small" color={colors.white} />
              ) : (
                <Text style={styles.submitButtonText}>Upload</Text>
              )}
            </TouchableOpacity>

            <TouchableOpacity
              style={[styles.button, styles.cancelButton]}
              onPress={() => {
                clearData(); // Clear all form data and images
                onClose(); // Close the modal
              }}
            >
              <Text style={styles.cancelButtonText}>Cancel</Text>
            </TouchableOpacity>
          </View>
        </View>
      </RNModal>

      <UploadPrescriptionScreen
        visible={modalVisible}
        onClose={() => setModalVisible(false)}
        onGallery={() => {
          console.log("283 opengallery");
          setModalVisible(false);
          openGallery();
        }}
        onCamera={() => {
          console.log("288 camera");
          setModalVisible(false);
          openCamera();
        }}
      />
    </>
  );
};

export default SubmitPrescriptions;
