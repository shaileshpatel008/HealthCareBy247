import React, { useEffect, useMemo, useRef, useState } from "react";
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  TouchableOpacity,
  SafeAreaView,
  Image,
  ActivityIndicator,
  Alert,
  Modal as RNModal,
} from "react-native";
import DatePicker from "react-native-date-picker";
import { format } from "date-fns";
import { ScrollView } from "react-native-gesture-handler";
import { KeyboardAwareScrollView } from "react-native-keyboard-aware-scroll-view";
import { launchCamera, launchImageLibrary } from "react-native-image-picker";
import Geolocation from "@react-native-community/geolocation";

import common from "../styles/commonStyle";
import styles from "../styles/stylesBookAVisit";
import images from "../utils/images";
import DropdownComponent from "./DropDownComponent";
import stylesFonts from "../styles/styleFonts";
import { api } from "../utils/ApiService/api";
import LoaderScreen from "./LoaderScreen";
import UploadPrescriptionScreen from "./UploadPrescriptions";
import { useCart } from "../context/CartContext";
import { useFocusEffect } from "@react-navigation/native";

const PlaceInquery = ({ navigation, route }) => {
  const { state, dispatch } = useCart();

  const packageName = useMemo(
    () =>
      state.items
        .filter((item) => item.PackageId)
        .map((item) => ({
          label: item.Name,
          value: item.PackageId,
        })),
    [state.items]
  );

  const testName = useMemo(
    () =>
      state.items
        .filter((item) => item.ReportNo)
        .map((item) => ({
          label: item.ReportName,
          value: item.ReportNo,
        })),
    [state.items]
  );

  const { selectedPackageName, selectedTestName } = route.params;

  console.log("selectedPackageName============", route.params);
  console.log("selectedTestName============", testName);

  const [modalVisible, setModalVisible] = useState(false);
  const [selectedTimeSlot, setSelectedTimeSlot] = useState(null);
  const [selectedPackage, setSelectedPackage] = useState([]);
  const [selectedTest, setSelectedTest] = useState([]);
  const [selectedPincode, setSelectedPincode] = useState();
  const [selectedArea, setSelectedArea] = useState();
  const [isTimeSlotVisible, setIsTimeSlotVisible] = useState(false);
  const [isPackageVisible, setIsPackageVisible] = useState(false);
  const [isTestVisible, setIsTestVisible] = useState(false);
  const [isPincodeVisible, setIsPincodeVisible] = useState(false);
  const [isAreaVisible, setIsAreaVisible] = useState(false);

  useEffect(() => {
    setSelectedPackage(packageName);
    setSelectedTest(testName);
  }, [state.items]);

  const [timeSlots, setTimeSlots] = useState([]); // Store API Data
  const [packagesList, setPackages] = useState([]);
  const [reports, setReports] = useState([]);
  const [pincodes, setPincodes] = useState([]);
  const [areas, setAreas] = useState([]);
  const [loading, setLoading] = useState(true);
  const [imageUris, setImageUris] = useState([]);
  console.log("imageUris=============------------------", imageUris);

  const [fullImageUri, setFullImageUri] = useState(null);

  const toggleTimeslotForDropdown = () =>
    setIsTimeSlotVisible(!isTimeSlotVisible);
  const togglePackageDropdown = () => setIsPackageVisible(!isPackageVisible);
  const toggleTestDropdown = () => setIsTestVisible(!isTestVisible);
  const togglePincodeDropdown = () => setIsPincodeVisible(!isPincodeVisible);
  const toggleAreaDropdown = () => setIsAreaVisible(!isAreaVisible);

  const [date, setDate] = useState(new Date());
  const [open, setOpen] = useState(false);
  const [email, setEmail] = useState("");
  const [name, setName] = useState("");
  const [mobilenumber, setMobileNumber] = useState("");
  const [address_1, setAddress_1] = useState("");
  const [address_2, setAddress_2] = useState("");
  const [location, setLocation] = useState("");
  const [errors, setErrors] = useState({});
  const scrollViewRef = useRef(null);

  // Get current location
  const startWatchingLocation = () => {
    setLoading(true);
    Geolocation.getCurrentPosition(
      (position) => {
        setLoading(false);
        setLocation(position.coords);
      },
      (error) => {
        setLoading(false);
        Alert.alert(
          "Location Error",
          "Location is off. Please turn on location."
        );
      }
      // {
      //   enableHighAccuracy: true,
      //   timeout: 15000, // Wait up to 15 seconds for the location
      //   maximumAge: 10000, // Accept a cached location that is up to 10 seconds old
      // }
    );
  };

  const OpenLocationPicker = async () => {
    startWatchingLocation();
  };

  const openCamera = () => {
    const options = {
      mediaType: "photo",
      quality: 0.5,
      saveToPhotos: true,
      presentationStyle: "fullScreen",
    };
    setTimeout(() => {
      launchCamera(options, (response) => {
        if (response.didCancel) {
          Alert.alert("User cancelled camera");
        } else if (response.errorMessage) {
          Alert.alert("Camera Error:", response.errorMessage);
        } else {
          setImageUris([...imageUris, response.assets[0].uri]);
        }
      });
    }, 100);
  };

  // 📂 Open Gallery (Multiple Selection)
  const openGallery = () => {
    const options = {
      mediaType: "photo",
      quality: 0.5,
      selectionLimit: 5,
      presentationStyle: "fullScreen",
    };
    setTimeout(() => {
      launchImageLibrary(options, (response) => {
        if (response.didCancel) {
          Alert.alert("User cancelled gallery");
        } else if (response.errorMessage) {
          Alert.alert("Gallery Error:", response.errorMessage);
        } else {
          const newImages = response.assets.map((asset) => asset.uri);
          setImageUris([...imageUris, ...newImages]);
        }
      });
    }, 100);
  };

  // Remove Image
  const removeImage = (index) => {
    const updatedUris = [...imageUris];
    updatedUris.splice(index, 1);
    setImageUris(updatedUris);
  };

  // Open Full Image
  const viewFullImage = (uri) => {
    setFullImageUri(uri);
  };

  const fetchTimeSlot = async () => {
    try {
      const response = await api.get("/timeSlot.php");
      if (response.success == true) {
        console.log("Time slot:", response.data.data);
        setTimeSlots(response.data.data);
      } else {
        setErrors("Failed to fetch reports");
      }
    } catch (err) {
      setErrors(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchPackage = async () => {
    try {
      const response = await api.get("/packageswithTest.php");
      if (response.success == true) {
        console.log("Test List:", response.data.data);
        setPackages(response.data.data);
      } else {
        setErrors("Failed to fetch reports");
      }
    } catch (err) {
      setErrors(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchReports = async () => {
    try {
      const response = await api.get("/reportsinfo.php");
      console.log("API Response:", response.data.data); // Log the response
      if (response.success === true) {
        setReports(response.data.data);
      } else {
        setErrors("Failed to fetch reports");
      }
    } catch (err) {
      setErrors(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchPincode = async () => {
    try {
      const response = await api.get("/pincodeinfo.php");
      console.log("API Response:", response.data.data); // Log the response
      if (response.success === true) {
        setPincodes(response.data.data);
      } else {
        setErrors("Failed to fetch reports");
      }
    } catch (err) {
      setErrors(err.message);
    } finally {
      setLoading(false);
    }
  };

  const fetchArea = async () => {
    try {
      const response = await api.get("/locationinfo.php");
      console.log("API Response:", response.data.data); // Log the response
      if (response.success === true) {
        setAreas(response.data.data);
      } else {
        setErrors("Failed to fetch reports");
      }
    } catch (err) {
      setErrors(err.message);
    } finally {
      setLoading(false);
    }
  };

  // Fetch data when component mounts
  useFocusEffect(
    React.useCallback(() => {
      fetchPincode();
      fetchArea();
      fetchTimeSlot();
      fetchPackage();
      fetchReports();
    }, [selectedPackage, selectedTest])
  );

  useFocusEffect(
    React.useCallback(() => {
      setErrors({});
    }, [])
  );

  const getUpcomingTimeSlots = (slots, selectedDate) => {
    const now = new Date();
    const currentDate = now.toDateString();
    const targetDate = new Date(selectedDate).toDateString();

    if (currentDate === targetDate) {
      const currentHours = now.getHours();
      const currentMinutes = now.getMinutes();

      return slots.filter((slot) => {
        const [slotHours, slotMinutes] = slot.Slot.split(":").map(Number);
        if (slotHours > currentHours) return true;
        if (slotHours === currentHours && slotMinutes > currentMinutes)
          return true;
        return false;
      });
    }
    return slots; // Return all slots for future dates
  };

  // Reset selectedTimeSlot when date changes
  useEffect(() => {
    setSelectedTimeSlot(null); // Clear selectedTimeSlot
    setIsTimeSlotVisible(false); // Close dropdown to reset UI
  }, [date]);

  const upcomingTimeSlots = getUpcomingTimeSlots(timeSlots, date);

  const labelValuePairsTimeSlot = upcomingTimeSlots.map((slot) => ({
    label: slot.Slot,
    value: slot.TimeSlotID,
  }));

  const labelValuePairsTest = reports.map((rpt) => ({
    label: rpt.ReportName,
    value: rpt.ReportNo,
    price: rpt.ReportRate ?? 0,
  }));

  const labelValuePairsPackage = packagesList.map((pkg) => ({
    label: pkg.Name,
    value: pkg.PackageId,
    price: pkg.DiscountRate ?? 0,
  }));

  const totalAmount = useMemo(() => {
    const packageTotal = selectedPackage.reduce((sum, selected) => {
      const found = labelValuePairsPackage.find(
        (item) => item.value === selected.value
      );
      return sum + (found?.price || 0);
    }, 0);

    const testTotal = selectedTest.reduce((sum, selected) => {
      const found = labelValuePairsTest.find(
        (item) => item.value === selected.value
      );
      return sum + (found?.price || 0);
    }, 0);

    return packageTotal + testTotal;
  }, [selectedPackage, selectedTest]);

  useEffect(() => {
    console.log("selectedPackage:-----========0000", selectedPackage);
    console.log("selectedTest:-------========00000", selectedTest);
  }, [selectedPackage, selectedTest]);

  const labelValuePincode = pincodes.map((obj) => ({
    label: obj.PincodeNumber.toString(),
    value: obj.PincodeID,
  }));

  const labelValueArea = areas.map((obj) => ({
    label: obj.LocationName,
    value: obj.LocationID,
  }));

  const updateAssingPackage = (selectedValues) => {
    setSelectedPackage(selectedValues);
    const selectedPackageIds = new Set(selectedValues.map((val) => val.value));

    // Get all tests from current state (items with ReportNo)
    const currentTests = state.items.filter((item) => item.ReportNo);

    // Get all selected packages (from original data or wherever you store them)
    const selectedPackages = packagesList.filter((pkg) =>
      selectedPackageIds.has(pkg.PackageId)
    );

    dispatch({
      type: "LOAD_CART",
      payload: [...currentTests, ...selectedPackages],
    });
  };

  const updateAssingTest = (selectedValues) => {
    setSelectedTest(selectedValues);
    const selectedTestIds = new Set(selectedValues.map((val) => val.value));

    // Get all packages from current state (items with PackageId)
    const currentPackages = state.items.filter((item) => item.PackageId);

    // Get all selected tests (from original data or wherever you store them)
    const selectedTests = reports.filter((test) =>
      selectedTestIds.has(test.ReportNo)
    );

    dispatch({
      type: "LOAD_CART",
      payload: [...currentPackages, ...selectedTests],
    });
  };

  const today = new Date();
  // Date 7 days from today (max date)
  const sevenDaysFromToday = new Date();
  sevenDaysFromToday.setDate(today.getDate() + 7);

  const validateEmail = (email) => {
    const regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    return regex.test(email);
  };

  // Refs for TextInput components
  const nameInputRef = useRef(null);
  const mobileNumberInputRef = useRef(null);
  const emailInputRef = useRef(null);
  const address1InputRef = useRef(null);
  const address2InputRef = useRef(null);

  // Refs for input fields and sections
  const nameRef = useRef(null);
  const mobileNumberRef = useRef(null);
  const emailRef = useRef(null);
  const address1Ref = useRef(null);
  const address2Ref = useRef(null);
  const areaRef = useRef(null);
  const pincodeRef = useRef(null);
  const locationRef = useRef(null);
  const dateRef = useRef(null);
  const timeSlotRef = useRef(null);
  const packageRef = useRef(null);
  const testRef = useRef(null);

  const SubmitVisit = () => {
    let newErrors = {};

    if (name.length < 3) newErrors.name = "Please enter a valid name!";
    if (mobilenumber.length !== 10)
      newErrors.mobilenumber = "Please enter a valid mobile number!";
    if (address_1.length < 5)
      newErrors.address_1 = "Please enter a valid address!";
    if (!selectedArea) newErrors.selectedArea = "Please select an area!";
    if (!selectedPincode)
      newErrors.selectedPincode = "Please select a pincode!";
    if (!location) newErrors.location = "Please select your location!";
    if (!selectedTimeSlot)
      newErrors.selectedTimeSlot = "Please select an appointment time!";
    if (
      selectedPackage.length === 0 &&
      selectedTest.length === 0 &&
      imageUris.length === 0
    ) {
      newErrors.selection =
        "Please select at least a package, test, or upload your prescription!";
    }
    if (email.length !== 0 && !validateEmail(email))
      newErrors.email = "Please enter a valid email!";

    setErrors(newErrors);

    if (Object.keys(newErrors).length > 0) {
      const firstError = Object.keys(newErrors)[0];
      let targetRef; // For scrolling
      let inputRef; // For focusing

      switch (firstError) {
        case "name":
          targetRef = nameRef;
          inputRef = nameInputRef;
          break;
        case "mobilenumber":
          targetRef = mobileNumberRef;
          inputRef = mobileNumberInputRef;
          break;
        case "email":
          targetRef = emailRef;
          inputRef = emailInputRef;
          break;
        case "address_1":
          targetRef = address1Ref;
          inputRef = address1InputRef;
          break;
        case "selectedArea":
          targetRef = areaRef;
          break;
        case "selectedPincode":
          targetRef = pincodeRef;
          break;
        case "location":
          targetRef = locationRef;
          break;
        case "selectedTimeSlot":
          targetRef = timeSlotRef;
          break;
        case "selection":
          targetRef = testRef;
          break;
        default:
          targetRef = null;
      }

      if (targetRef?.current && scrollViewRef.current) {
        setTimeout(() => {
          targetRef.current.measure((x, y, width, height, pageX, pageY) => {
            console.log("Field Position:", {
              x,
              y,
              width,
              height,
              pageX,
              pageY,
            });
            const scrollPosition = pageY - 15; // Adjusted offset
            console.log("Scroll Position:", scrollPosition);
            scrollViewRef.current.scrollToPosition(
              0,
              scrollPosition > 0 ? scrollPosition : 0,
              true
            );
            // Focus the input if it’s a TextInput field
            if (inputRef?.current) {
              inputRef.current.focus();
            }
          });
        }, 100); // 100ms delay to allow layout to settle
      }
    } else {
      SubmitBookAVisitRequest();
    }
  };

  const SubmitBookAVisitRequest = async () => {
    setLoading(true);

    const timestamp = new Date().getTime();

    const formData = new FormData();
    console.log("formData=====================", formData);

    formData.append("MobileNo", mobilenumber);
    formData.append("Name", name);
    formData.append("Address1", address_1);
    formData.append("Address2", address_2);
    formData.append("Email", email);
    formData.append("TimeSlot", selectedTimeSlot.label);
    formData.append("Latitude", location.latitude ?? "0.0");
    formData.append("Longitude", location.longitude ?? "0.0");
    formData.append("RegDate", format(date, "yyyy-MM-dd"));
    console.log("Form Data Parts:", formData._parts);

    formData.append("Area", selectedArea.label);
    formData.append("Pincode", selectedPincode.label);
    formData.append("Amount", totalAmount.toString());

    console.log("Form Data Parts:", formData._parts);
    if (selectedPackage != null) {
      formData.append(
        "Package",
        selectedPackage.map((item) => item.label).join(",")
      );
    }

    if (selectedTest != null) {
      formData.append("Test", selectedTest.map((item) => item.label).join(","));
    }

    // Append multiple images
    if (imageUris.length > 0) {
      imageUris.forEach((uri, index) => {
        formData.append(`Prescription[${index}]`, {
          uri: uri,
          type: "image/jpeg",
          name: `prescription_${timestamp}_${index}.jpg`,
        });
      });
    }

    console.log("Form Data Parts:", formData._parts);

    try {
      let response = await fetch(
        "https://healthcare24x7.com/api/registration.php",
        {
          method: "POST",
          body: formData,
          headers: {
            "Content-Type": "multipart/form-data",
            Accept: "application/json",
          },
        }
      );

      let jsonResponse = await response.json();
      console.log(
        "jsonResponse:===============--------------------",
        jsonResponse
      );
      setLoading(false);

      if (jsonResponse.status === "success") {
        Alert.alert(
          "Healthcare 24x7",
          `Your inquiry (ID: ${jsonResponse.id}) has been submitted successfully, our representative will call you shortly.`,
          [
            {
              text: "OK",
              onPress: () => {
                clearData();
                dispatch({ type: "CLEAR_CART" });
                navigation.navigate("HomeDrawer");
              }, // Handle the tap on the "OK" button
            },
          ]
        );
      } else {
        Alert.alert(
          "Error",
          jsonResponse.message ||
            "Something went wrong. Please try again later."
        );
      }
    } catch (error) {
      Alert.alert(error.message);
      console.log("Faild Reposne", error.message);
      setLoading(false);
    }
  };

  // useEffect(() => {
  //   clearData();
  // }, [route?.params?.clearname]);

  const clearData = () => {
    setName("");
    setMobileNumber("");
    setEmail("");
    setAddress_1("");
    setAddress_2("");
    setSelectedArea();
    setSelectedPincode();
    setSelectedTimeSlot();
    setSelectedPackage([]);
    setSelectedTest([]);
    setImageUris([]);
    setLocation("");
    setErrors({});
    setDate(new Date());
  };

  const handleUpload = () => {
    setModalVisible(true);
  };

  // Scroll to top when screen comes into focus
  useFocusEffect(
    React.useCallback(() => {
      if (scrollViewRef.current) {
        scrollViewRef.current.scrollToPosition(0, 0, false); // Scroll to top
      }
    }, [])
  );

  return (
    <SafeAreaView style={common.container}>
      <View style={styles.background}>
        {/* Header */}
        <View style={common.header}>
          <TouchableOpacity
            onPress={() => {
              navigation.goBack();
              clearData();
            }}
          >
            <Image source={images.back} style={styles.headerIcon} />
          </TouchableOpacity>
          <Text style={[styles.headerTitle, stylesFonts.bold]}>
            Place Inquiry
          </Text>
          <TouchableOpacity>
            <View style={styles.hideIcon} />
          </TouchableOpacity>
        </View>
        {/* Fourm Fill data List */}
        <KeyboardAwareScrollView
          ref={scrollViewRef} // Attach ref to KeyboardAwareScrollView
          style={styles.containerView}
          contentContainerStyle={{ flexGrow: 1 }} // Ensure content grows properly
          keyboardShouldPersistTaps="handled" // Handle taps properly
        >
          {loading ? (
            <LoaderScreen visible={loading} />
          ) : (
            // <ScrollView
            //   ref={scrollViewRef}
            //   style={styles.containerView}>
            <View style={[styles.columnStyle, styles.containerView]}>
              {/* <View style={styles.mainSectionView}>
                <Text style={
                  [stylesFonts.medium, styles.fourmHeaderText]
                }>Fill out the details to schedule
                </Text>
                <Text style={
                  [stylesFonts.medium, styles.fourmHeaderText]
                }>
                  your appointment.
                </Text>
              </View> */}

              {/* Text Filed Name */}
              <View
                ref={nameRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Name*
                </Text>
                <TextInput
                  // ref={nameInputRef}
                  style={styles.textFiled}
                  placeholder="Enter Name"
                  value={name}
                  keyboardType="default"
                  autoCapitalize="words"
                  onChangeText={(text) => {
                    const filteredText = text.replace(/[^a-zA-Z\s]/g, ""); // Only alphabets
                    setName(filteredText);
                    setErrors((prev) => ({ ...prev, name: null })); // Clear error on typing
                  }}
                />
                {errors.name && (
                  <Text style={styles.errorText}>{errors.name}</Text>
                )}
              </View>

              {/* Text Filed Mobile Number */}
              <View
                ref={mobileNumberRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Mobile Number*
                </Text>
                <TextInput
                  ref={mobileNumberInputRef}
                  style={styles.textFiled}
                  placeholder="Enter Mobile Number"
                  keyboardType="phone-pad"
                  value={mobilenumber}
                  maxLength={10} // Updates state on text change
                  onChangeText={(text) => {
                    setMobileNumber(text);
                    setErrors((prev) => ({ ...prev, mobilenumber: null })); // Clear error
                  }}
                />
                {errors.mobilenumber && (
                  <Text style={styles.errorText}>{errors.mobilenumber}</Text>
                )}
              </View>

              {/* Text Filed Email */}
              <View
                ref={emailRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Email Address
                </Text>
                <TextInput
                  ref={emailInputRef}
                  style={styles.textFiled}
                  placeholder="Enter Email"
                  keyboardType="email-address"
                  value={email}
                  onChangeText={(text) => {
                    setEmail(text);
                    setErrors((prev) => ({ ...prev, email: null })); // Clear error
                  }}
                />
                {errors.email && (
                  <Text style={styles.errorText}>{errors.email}</Text>
                )}
              </View>

              {/* Text Filed Address 1  */}
              <View
                ref={address1Ref}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Address 1*
                </Text>
                <TextInput
                  ref={address1InputRef}
                  style={styles.textFiled}
                  placeholder="Enter Your Address"
                  keyboardType="default"
                  value={address_1}
                  onChangeText={(text) => {
                    setAddress_1(text);
                    setErrors((prev) => ({ ...prev, address_1: null })); // Clear error
                  }}
                />
                {errors.address_1 && (
                  <Text style={styles.errorText}>{errors.address_1}</Text>
                )}
              </View>

              {/* Text Filed Address 2 */}
              <View
                ref={address2Ref}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Address 2
                </Text>
                <TextInput
                  style={styles.textFiled}
                  placeholder="Enter Additional Address Details"
                  value={address_2}
                  onChangeText={setAddress_2} // Updates state on text change
                />
              </View>

              {/* Text Filed Area */}
              <View
                ref={areaRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Area*
                </Text>
                <DropdownComponent
                  isClearable={true}
                  placeholder="Select Area"
                  selectedValue={selectedArea}
                  isSearchEnabled={true}
                  isMultiSelect={false}
                  data={labelValueArea}
                  isVisible={isAreaVisible}
                  onClose={toggleAreaDropdown}
                  customStyles={styles.filedText}
                  onSelect={(value) => {
                    setSelectedArea(value);
                    setErrors((prev) => ({ ...prev, selectedArea: null })); // Clear error
                  }}
                  onPress={toggleAreaDropdown}
                />
                {errors.selectedArea && (
                  <Text style={styles.errorText}>{errors.selectedArea}</Text>
                )}
              </View>

              {/* Text Filed Pincode */}
              <View
                ref={pincodeRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Pincode*
                </Text>
                <DropdownComponent
                  isClearable={true}
                  placeholder="Select Pincode"
                  selectedValue={selectedPincode}
                  isSearchEnabled={true}
                  isMultiSelect={false}
                  data={labelValuePincode}
                  isVisible={isPincodeVisible}
                  onClose={togglePincodeDropdown}
                  onSelect={(value) => {
                    setSelectedPincode(value);
                    setErrors((prev) => ({ ...prev, selectedPincode: null })); // Clear error
                  }}
                  customStyles={styles.filedText}
                  onPress={togglePincodeDropdown}
                />
                {errors.selectedPincode && (
                  <Text style={styles.errorText}>{errors.selectedPincode}</Text>
                )}
              </View>

              {/* Text Filed Location */}
              <View
                ref={locationRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  Visit Location*
                </Text>
                <TouchableOpacity
                  style={[styles.textFiled, styles.centerTouchble]}
                  onPress={() => {
                    OpenLocationPicker();
                    setErrors((prev) => ({ ...prev, location: null })); // Clear error on selecting location
                  }}
                >
                  {location ? (
                    <Text style={[stylesFonts.semibold]}>
                      {location.latitude}, {location.longitude}
                    </Text>
                  ) : (
                    <Text style={[stylesFonts.semibold]}>
                      Get Latitude & Longitude
                    </Text>
                  )}
                </TouchableOpacity>
                {errors.location && (
                  <Text style={styles.errorText}>{errors.location}</Text>
                )}
              </View>

              {/* Text Filed Appoiment Date */}
              <View
                ref={dateRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <View style={[styles.rowStyle, styles.rowContainer]}>
                  <Text style={[stylesFonts.semibold, styles.filedText]}>
                    Appointment Date*
                  </Text>
                  <Image source={images.date} style={styles.icon} />
                </View>
                <TouchableOpacity
                  style={[styles.textFiled, styles.centerTouchble]}
                  onPress={() => setOpen(true)}
                >
                  <Text style={[stylesFonts.semibold]}>
                    {date
                      ? format(date, "dd-MM-yyyy")
                      : "Select Appointment Date"}
                  </Text>
                </TouchableOpacity>
                <DatePicker
                  modal
                  open={open}
                  date={date || new Date()}
                  mode="date"
                  onConfirm={(selectedDate) => {
                    setOpen(false);
                    setDate(selectedDate);
                    setErrors((prev) => ({ ...prev, date: null }));
                  }}
                  onCancel={() => setOpen(false)}
                  minimumDate={today}
                />
                {errors.date && (
                  <Text style={styles.errorText}>{errors.date}</Text>
                )}
              </View>

              <View
                ref={timeSlotRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <View style={[styles.rowStyle, styles.rowContainer]}>
                  <Text style={[stylesFonts.semibold, styles.filedText]}>
                    Appointment Time*
                  </Text>
                  <Image source={images.time} style={styles.icon} />
                </View>
                <DropdownComponent
                  isClearable={true}
                  placeholder="Select Appointment Time"
                  selectedValue={selectedTimeSlot}
                  isSearchEnabled={true}
                  data={labelValuePairsTimeSlot}
                  isVisible={isTimeSlotVisible}
                  customStyles={styles.filedText}
                  onClose={toggleTimeslotForDropdown}
                  onSelect={(value) => {
                    setSelectedTimeSlot(value);
                    setErrors((prev) => ({ ...prev, selectedTimeSlot: null }));
                  }}
                  onPress={toggleTimeslotForDropdown}
                />
                {errors.selectedTimeSlot && (
                  <Text style={styles.errorText}>
                    {errors.selectedTimeSlot}
                  </Text>
                )}
              </View>

              {/* Text Filed Package */}
              <View
                ref={packageRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  {selectedPackage.length > 0
                    ? `Select Package (${selectedPackage.length})`
                    : "Select Package"}
                </Text>
                <DropdownComponent
                  isClearable={true}
                  placeholder="Select Package"
                  selectedValue={selectedPackage}
                  isSearchEnabled={true}
                  isMultiSelect={true}
                  data={labelValuePairsPackage}
                  isVisible={isPackageVisible}
                  onClose={togglePackageDropdown}
                  onSelect={updateAssingPackage}
                  onPress={togglePackageDropdown}
                />
              </View>

              {/* Text Filed Test */}
              <View
                ref={testRef}
                style={[styles.sectionView, styles.columnStyle]}
              >
                <Text style={[stylesFonts.semibold, styles.filedText]}>
                  {selectedTest.length > 0
                    ? `Select Test (${selectedTest.length})`
                    : "Select Test"}
                </Text>
                <DropdownComponent
                  isClearable={true}
                  placeholder="Select Test"
                  selectedValue={selectedTest}
                  isSearchEnabled={true}
                  isMultiSelect={true}
                  data={labelValuePairsTest}
                  isVisible={isTestVisible}
                  onClose={toggleTestDropdown}
                  onSelect={(value) => {
                    updateAssingTest(value);
                    setErrors((prev) => ({ ...prev, selection: null })); // Clear error on selecting a test
                  }}
                  onPress={toggleTestDropdown}
                />
                {errors.selection && (
                  <Text style={styles.errorText}>{errors.selection}</Text>
                )}
              </View>

              {/* Button Prescriptions */}
              <View style={[styles.sectionView, styles.columnStyle]}>
                {/* Hide "Upload Prescription" button if images are selected */}
                {imageUris.length === 0 && (
                  <TouchableOpacity
                    style={styles.buttonUpload}
                    onPress={handleUpload}
                  >
                    <Image source={images.upload} style={styles.icon} />
                    <Text style={[styles.buttonText, stylesFonts.semibold]}>
                      Upload Prescription
                    </Text>
                  </TouchableOpacity>
                )}

                {/* Image Previews */}
                <ScrollView horizontal style={styles.imagePreviewContainer}>
                  {imageUris.map((uri, index) => (
                    <View key={`${uri}-${index}`} style={styles.imageContainer}>
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

                  {/* "+" Icon to Add More Images */}
                  {imageUris.length > 0 && (
                    <TouchableOpacity
                      style={styles.addMoreButton}
                      onPress={handleUpload}
                    >
                      <Text style={styles.addMoreText}>+</Text>
                    </TouchableOpacity>
                  )}
                </ScrollView>

                {/* Full Image Modal */}
                {fullImageUri && (
                  <RNModal visible={true} transparent={true}>
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
                )}
              </View>

              {/* Button Submit */}
              <View style={[styles.sectionView, styles.columnStyle]}>
                <TouchableOpacity
                  style={styles.buttonSubmit}
                  onPress={() => {
                    SubmitVisit();
                  }}
                >
                  <Text style={[styles.submitText, stylesFonts.semibold]}>
                    Submit
                  </Text>
                </TouchableOpacity>
              </View>
            </View>
            // </ScrollView>
          )}
        </KeyboardAwareScrollView>
      </View>
      <UploadPrescriptionScreen
        visible={modalVisible}
        onClose={() => setModalVisible(false)}
        onGallery={() => {
          console.log("Gallery Selected");
          setModalVisible(false);
          openGallery();
        }}
        onCamera={() => {
          setModalVisible(false);
          openCamera();
        }}
      />
    </SafeAreaView>
  );
};

export default PlaceInquery;

const pickerSelectStyles = StyleSheet.create({
  inputIOS: {
    fontSize: 16,
    paddingVertical: 12,
    paddingHorizontal: 10,
    borderWidth: 1,
    borderColor: "gray",
    borderRadius: 4,
    color: "black",
    marginBottom: 20,
  },
  inputAndroid: {
    fontSize: 16,
    paddingVertical: 8,
    paddingHorizontal: 10,
    borderWidth: 1,
    borderColor: "gray",
    borderRadius: 4,
    color: "black",
    marginBottom: 20,
  },
});
