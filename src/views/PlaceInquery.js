import React, {useEffect,useState} from 'react';
import { View, Text, TextInput,StyleSheet, TouchableOpacity, SafeAreaView,Image,ActivityIndicator, Alert } from 'react-native';
import DatePicker from 'react-native-date-picker';
import { format } from 'date-fns';
import { ScrollView } from 'react-native-gesture-handler';
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view';
import { launchCamera, launchImageLibrary } from 'react-native-image-picker';
import Geolocation from '@react-native-community/geolocation';

import common from '../styles/commonStyle';
import styles from '../styles/stylesPlaceInquery';
import images from '../utils/images';
import DropdownComponent from './DropDownComponent';
import stylesFonts from '../styles/styleFonts';
import { api } from '../utils/ApiService/api';
import LoaderScreen from './LoaderScreen';
import UploadPrescriptionScreen from './UploadPrescriptions';
import { useCart } from '../context/CartContext';
import { get } from 'react-native/Libraries/TurboModule/TurboModuleRegistry';

const PlaceInquery = ({ navigation,route }) => {  
    const { state, dispatch} = useCart();
   
    const { selectedPackageName, selectedTestName } = route.params; 
    const [modalVisible, setModalVisible] = useState(false);
    const [imageUri, setImageUri] = useState(null);
    const [selectedTimeSlot, setSelectedTimeSlot] = useState();
    const [selectedPackage, setSelectedPackage] = useState(selectedPackageName);
    const [selectedTest, setSelectedTest] = useState(selectedTestName);
    const [selectedPincode, setSelectedPincode] = useState();
    const [selectedArea, setSelectedArea] = useState();
    const [isTimeSlotVisible, setIsTimeSlotVisible] = useState(false);
    const [isPackageVisible, setIsPackageVisible] = useState(false);
    const [isTestVisible, setIsTestVisible] = useState(false);
    const [isPincodeVisible, setIsPincodeVisible] = useState(false);
    const [isAreaVisible, setIsAreaVisible] = useState(false);

    const [timeSlots, setTimeSlots] = useState([]); // Store API Data
    const [packagesList, setPackages] = useState([]);
    const [reports, setReports] = useState([]);
    const [pincodes, setPincodes] = useState([]);
    const [areas, setAreas] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
  
    const toggleTimeslotForDropdown = () => setIsTimeSlotVisible(!isTimeSlotVisible);
    const togglePackageDropdown = () => setIsPackageVisible(!isPackageVisible);
    const toggleTestDropdown = () => setIsTestVisible(!isTestVisible);
    const togglePincodeDropdown = () => setIsPincodeVisible(!isPincodeVisible);
    const toggleAreaDropdown = () => setIsAreaVisible(!isAreaVisible);
   
   // Get current location
  const getLocation = async () => {
    setLoading(true);
      Geolocation.getCurrentPosition(
      (position) => {
        setLoading(false);
        console.log("Locations:");
        console.log(position);
        setLocation(position.coords);
      },
      (error) => {
        setLoading(false);
        Alert.alert(error.message);
      },
      {    
        enableHighAccuracy: true,
        timeout: 50000,
        maximumAge: 10000, 
      } 
    );
  };

  const OpenLocationPicker = async () => {
    getLocation();
  };

 // 📷 Open Camera
  const openCamera = () => {
    const options = {
      mediaType: 'photo',
      quality: 1,
      saveToPhotos: true,
    };

    launchCamera(options, (response) => {
      if (response.didCancel) {
        Alert.alert('User cancelled camera');
      } else if (response.errorMessage) {
        Alert.alert('Camera Error:', response.errorMessage);
      } else {
        setImageUri(response.assets[0].uri);
        
      }
    });
  };

  // 📂 Open Gallery
  const openGallery = () => {
    const options = {
      mediaType: 'photo',
      quality: 1,
    };

    launchImageLibrary(options, (response) => {
      if (response.didCancel) {
        Alert.alert('User cancelled gallery');
      } else if (response.errorMessage) {
        Alert.alert('Gallery Error:', response.errorMessage);
      } else {
        setImageUri(response.assets[0].uri);
        
      }
    });
  };

  const fetchTimeSlot = async () => {
    try {
        const response = await api.get('/timeSlot.php');
        if (response.success == true) {
          console.log("Time slot:",response.data.data);
          setTimeSlots(response.data.data);
        } else {
            setError('Failed to fetch reports');
        }
    } catch (err) {
        setError(err.message);
    } finally {
        setLoading(false);
    }
  };  

  const fetchPackage = async () => {
        try {
            const response = await api.get('/packageswithTest.php');
            if (response.success == true) {
              console.log("Test List:",response.data.data);
                setPackages(response.data.data);
            } else {
                setError('Failed to fetch reports');
            }
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

  const fetchReports = async () => {
        try {
              const response = await api.get('/reportsinfo.php');
              console.log("API Response:", response.data.data); // Log the response
              if (response.success === true) {

                  setReports(response.data.data);
              } else {
                  setError('Failed to fetch reports');
              }
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
          }; 

  const fetchPincode = async () => {
    try {
          const response = await api.get('/pincodeinfo.php');
          console.log("API Response:", response.data.data); // Log the response
          if (response.success === true) {
              setPincodes(response.data.data);
          } else {
              setError('Failed to fetch reports');
          }
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
      }; 
      
  const fetchArea = async () => {
    try {
          const response = await api.get('/locationinfo.php');
          console.log("API Response:", response.data.data); // Log the response
          if (response.success === true) {
              setAreas(response.data.data);
          } else {
              setError('Failed to fetch reports');
          }
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
      };     
  // Fetch data when component mounts
  useEffect(() => {
      fetchPincode();
      fetchArea();
      fetchTimeSlot();
      fetchPackage();
      fetchReports();
      getLocation();
    }, []);

      
  const labelValuePairsTimeSlot = timeSlots.map(slot => ({
    label: slot.Slot,
    value: slot.TimeSlotID,
  }));

  const labelValuePairsTest = reports.map(rpt => ({
    label: rpt.ReportName,
    value: rpt.ReportNo,
  }));

  const labelValuePairsPackage = packagesList.map(pkg => ({
    label: pkg.Name,
    value: pkg.PackageId,
  }));

  const labelValuePincode = pincodes.map(obj => ({
    label: obj.PincodeNumber.toString(),
    value: obj.PincodeID,
  }));

  const labelValueArea = areas.map(obj => ({
    label: obj.LocationName,
    value: obj.LocationID,
  }));

  const updateAssingPackage = (value) => {
    setSelectedPackage(value.map((val) => val));
    console.log("SelectedPackage:",selectedPackage);
  };

  const updateAssingTest = (value) => {
    setSelectedTest(value.map((val) => val));
    console.log("SelectedTests:",selectedTest);
  };
    
  const today = new Date();
  // Date 7 days from today (max date)
  const sevenDaysFromToday = new Date();
  sevenDaysFromToday.setDate(today.getDate() + 7);
  
  const [date, setDate] = useState(new Date());
  const [open, setOpen] = useState(false);
  const [email, setEmail] = useState('');
  const [name, setName] = useState('');
  const [mobilenumber, setMobileNumber] = useState('');
  const [address_1, setAddress_1] = useState('');
  const [address_2, setAddress_2] = useState('');
  const [location, setLocation] = useState('');

  const validateEmail = (email) => {
    const regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
    return regex.test(email);
  };

 const SubmitVisit = () => {
    if (name.length < 3) {
        Alert.alert('Error', 'Please enter valid name!');
      } 
      else if (mobilenumber.length != 10) {
        Alert.alert('Error', 'Please enter valid mobile number!');
      } 
      else if (address_1.length < 5) {
        Alert.alert('Error', 'Please enter valid address!');
      } 
      else if (selectedArea === null) {
        Alert.alert('Error', 'Please select area!');
      } 
      else if (selectedPincode === null) {
        Alert.alert('Error', 'Please select pincode!');
      } 
      else if (selectedTimeSlot === null) {
        Alert.alert('Error', 'Please select appointment time!');
      } 
      else if (selectedPackage.length == 0 && selectedTest.length == 0 && imageUri == null)  {
        Alert.alert('Error', 'Please select package or test or upload your prescriptions!');
      }
    else {
       if (email.length != 0 && !validateEmail(email)) {
            Alert.alert('Error', 'Please enter valid email!');
          } else{
            SubmitBookAVisitRequest();
          }
    }
  };

 const SubmitBookAVisitRequest = async () => {
    setLoading(true)

  const timestamp = new Date().getTime();

  const formData = new FormData();
        formData.append('MobileNo', mobilenumber);
        formData.append('Name', name);
        formData.append('Address1', address_1);
        formData.append('Address2', address_2);
        formData.append('Email', email);
        formData.append('TimeSlot', selectedTimeSlot.label);
        formData.append('Latitude', location.latitude ?? '0.0') ;
        formData.append('Longitude', location.longitude ?? '0.0');
        formData.append('RegDate', format(date, 'yyyy-MM-dd'));
        console.log("Form Data Parts:", formData._parts);
        
        formData.append('Area', selectedArea.label);
        console.log("Form Data Parts:", formData._parts);
        formData.append('Pincode', selectedPincode.label);
        console.log("Form Data Parts:", formData._parts);
        if (selectedPackage != null){
          formData.append('Package', selectedPackage.map(item => item.label).join(','));
          }

        if (selectedTest != null){
          formData.append('Test', selectedTest.map(item => item.label).join(','));
        }

        if (imageUri != null) {
          formData.append('Prescription', {
            uri: imageUri, // Use the uri directly
            type: 'image/jpeg', // Set the correct MIME type
            name: `image_${timestamp}.jpg`, 
        });
        }
        
      console.log("Form Data Parts:", formData._parts);

    try {
      let response = await fetch("https://healthcare24x7.com/api/registration.php", {
        method: "POST",
        body: formData,
        headers: {
          "Content-Type": "multipart/form-data",
          "Accept": "application/json",
        },
      });

      let jsonResponse = await response.json();
      setLoading(false)
      
    Alert.alert("Healthcare 24x7",jsonResponse.message.toString(),[ {
      text: 'OK',
      onPress: () => { 
        clearData()
        dispatch({ type: 'CLEAR_CART'});        
        navigation.navigate("HomeDrawer");
      }, // Handle the tap on the "OK" button
    },]);
    } catch (error) {
        Alert.alert(error.message);
      console.log("Faild Reposne",error.message);
      setLoading(false)
    }

  };
  const clearData = () => {
    setName('')
    setMobileNumber('')
    setEmail('')
    setAddress_1('')
    setAddress_2('')
    setSelectedArea()
    setSelectedPincode()
    setSelectedPincode()
    setSelectedTimeSlot()
    setSelectedPackage([])
    setSelectedTest([])
  }
  const handleUpload = () => {
    setModalVisible(true)
  };

  return (
    <SafeAreaView style={common.container}>
    <View style={styles.background}>
              {/* Header */}
      <View style={common.header}>
        <TouchableOpacity  onPress={() => navigation.goBack()}>
        <Image source={images.back} style={styles.headerIcon} />
        </TouchableOpacity>
        <Text style={[styles.headerTitle,stylesFonts.bold]}>Place Inquiry</Text>
        <TouchableOpacity>
        <View style={styles.hideIcon} />
        </TouchableOpacity>
      </View>
    {/* Fourm Fill data List */}
    <KeyboardAwareScrollView>
    {loading ? (
      <LoaderScreen visible={loading} />
      ):(
    <ScrollView style={styles.containerView}>
        <View style={[styles.columnStyle,styles.containerView]}>
            <View style={styles.sectionView}>
                <Text style={
                    [stylesFonts.medium,styles.fourmHeaderText]
                }>Fill out the details to schedule
                </Text>
                <Text style={
                    [stylesFonts.medium,styles.fourmHeaderText]
                }>
                    your inquiry appointment.
                </Text>
            </View>

             {/* Text Filed Name */}
             <View style={[styles.sectionView,styles.columnStyle]}>
                <Text style={[stylesFonts.semibold,styles.filedText]}>Name*</Text>
                <TextInput
                        style={styles.textFiled}
                        placeholder="Enter  Name"
                        value={name}
                        keyboardType='ascii-capable'
                        onChangeText={setName} // Updates state on text change
                />
                  {error ? <Text style={styles.error}>{error}</Text> : null}
             </View>



              {/* Text Filed Mobile Number */}
              <View style={[styles.sectionView,styles.columnStyle]}>
                <Text style={[stylesFonts.semibold,styles.filedText]}>Mobile Number*</Text>
                <TextInput
                        style={styles.textFiled}
                        placeholder="Enter  Mobile Number"
                        keyboardType='phone-pad'
                        value={mobilenumber}
                        onChangeText={setMobileNumber} // Updates state on text change
                        maxLength={10}// Updates state on text change
                />
             </View>

                {/* Text Filed Mobile Number */}
                <View style={[styles.sectionView,styles.columnStyle]}>
                <Text style={[stylesFonts.semibold,styles.filedText]}>Email Address</Text>
                <TextInput
                        style={styles.textFiled}
                        placeholder="Enter Email"
                        keyboardType='email-address'
                        value={email}
                        onChangeText={setEmail} // Updates state on text change
                />
             </View>

              {/* Text Filed Address 1  */}
              <View style={[styles.sectionView,styles.columnStyle]}>
                <Text style={[stylesFonts.semibold,styles.filedText]}>Address 1*</Text>
                <TextInput
                        style={styles.textFiled}
                        placeholder="Enter Your Address"
                        keyboardType='default'
                        value={address_1}
                        onChangeText={setAddress_1} // Updates state on text change
                />
             </View>

              {/* Text Filed Address 2 */}
                <View style={[styles.sectionView,styles.columnStyle]}>
                    <Text style={[stylesFonts.semibold,styles.filedText]}>Address 2</Text>
                    <TextInput
                            style={styles.textFiled}
                            placeholder="Enter Additional Address Details"
                            value={address_2}
                            onChangeText={setAddress_2} // Updates state on text change
                    />
                </View>

               {/* Text Filed Area */}
               <View style={[styles.sectionView,styles.columnStyle]}>
                <Text style={[stylesFonts.semibold,styles.filedText]}>Area*</Text>
                <DropdownComponent
                    isClearable={true}
                    placeholder='Select Area'
                    selectedValue={selectedArea}
                    isSearchEnabled={true}
                    isMultiSelect={false}
                    data={labelValueArea}
                    isVisible={isAreaVisible}
                    onClose={toggleAreaDropdown}
                    onSelect={setSelectedArea}
                    customStyles={styles.filedText}
                    onPress={toggleAreaDropdown}
                />
                </View>

                {/* Text Filed Pincode */}
                <View style={[styles.sectionView,styles.columnStyle]}>
                <Text style={[stylesFonts.semibold,styles.filedText]}>Pincode*</Text>
                <DropdownComponent
                    isClearable={true}
                    placeholder='Select Pincode'
                    selectedValue={selectedPincode}
                    isSearchEnabled={true}
                    isMultiSelect={false}
                    data={labelValuePincode}
                    isVisible={isPincodeVisible}
                    onClose={togglePincodeDropdown}
                    onSelect={setSelectedPincode}
                    customStyles={styles.filedText}
                    onPress={togglePincodeDropdown}
                />
                </View>

              {/* Text Filed Location */}
              <View style={[styles.sectionView,styles.columnStyle]}>
                          <Text style={[stylesFonts.semibold,styles.filedText]}>Visit Location*</Text>
                          <TouchableOpacity style={[styles.textFiled,styles.centerTouchble]}
                            onPress={(OpenLocationPicker)}>
                            
                      {(location)?  <Text style={[stylesFonts.semibold]}>{location.latitude},{location.longitude}</Text> : <Text style={[stylesFonts.semibold]}> Current Location </Text> }
                 </TouchableOpacity>
                </View>

                 {/* Text Filed Appoiment Date */}
                 <View style={[styles.sectionView,styles.columnStyle]}>
                 <View style={[styles.rowStyle,styles.rowContainer]}>
                    <Text style={[stylesFonts.semibold,styles.filedText]}>Appointment Date*</Text>
                    <Image source={images.date} style={styles.icon}></Image>
                 </View>
                    <TouchableOpacity style={[styles.textFiled,styles.centerTouchble]} onPress={() => setOpen(true)}>
                        <Text style={[stylesFonts.semibold]} >
                            {date ? format(date, 'yyyy-MM-dd') : 'Select Appoinment Date'} 
                        </Text>
                    </TouchableOpacity>                 
                    <DatePicker
                        modal
                        open={open}
                        date={date || new Date()} // Default to current date if null
                        mode="date"
                        onConfirm={(selectedDate) => {
                        setOpen(false);
                        setDate(selectedDate);
                        }}
                        onCancel={() => setOpen(false)}
                        minimumDate={today} // Min Date is today
                        maximumDate={sevenDaysFromToday} // Max Date is 7 days from today
                    />
                </View>

                 {/* Text Filed Appoiment Time */}
                 <View style={[styles.sectionView,styles.columnStyle]}>
                 <View style={[styles.rowStyle,styles.rowContainer]}>
                    <Text style={[stylesFonts.semibold,styles.filedText]}>Appointment Time*</Text>
                    <Image source={images.time} style={styles.icon}></Image>
                 </View>
                 <DropdownComponent
                    isClearable={true}
                    placeholder='Select Appointment Time'
                    selectedValue={selectedTimeSlot}
                    isSearchEnabled={true}
                    data={labelValuePairsTimeSlot}
                    isVisible={isTimeSlotVisible}
                    customStyles={styles.filedText}
                    onClose={toggleTimeslotForDropdown}
                    onSelect={setSelectedTimeSlot}
                    onPress={toggleTimeslotForDropdown}
                    />
        
                </View>

                 {/* Text Filed Package */}
                 <View style={[styles.sectionView,styles.columnStyle]}>
                 <Text style={[stylesFonts.semibold,styles.filedText]}>Select Package</Text>
                 <DropdownComponent
                    isClearable={true}                    
                    placeholder='Select Package'
                    selectedValue={selectedPackage}
                    isSearchEnabled={true}
                    isMultiSelect={true}
                    customStyles={styles.filedText}
                    data={labelValuePairsPackage}
                    isVisible={isPackageVisible}
                    onClose={togglePackageDropdown}
                    onSelect={updateAssingPackage}
                    onPress={togglePackageDropdown}
                />
                </View>

                 {/* Text Filed Test */}
                 <View style={[styles.sectionView,styles.columnStyle]}>
                 <Text style={[stylesFonts.semibold,styles.filedText]}>Select Test</Text>
                 <DropdownComponent
                    isClearable={true}
                    placeholder='Select Test'
                    selectedValue={selectedTest}
                    isSearchEnabled={true}
                    isMultiSelect={true}
                    data={labelValuePairsTest}
                    isVisible={isTestVisible}
                    onClose={toggleTestDropdown}
                    onSelect={updateAssingTest}
                    customStyles={styles.filedText}
                    onPress={toggleTestDropdown}
                />
                </View>

                   {/* Button Prescriptions */}
                <View style={[styles.sectionView,styles.columnStyle]}>
                 <TouchableOpacity style={styles.buttonUpload} onPress={handleUpload}>
                    <Image source={images.upload} style={styles.icon} />
                    <Text style={[styles.buttonText,stylesFonts.semibold]}>Upload Prescription</Text>
                 </TouchableOpacity>
                </View>

                    {/* Button Submit */}
                    <View style={[styles.sectionView,styles.columnStyle]}>
                 <TouchableOpacity style={styles.buttonSubmit}  onPress={() => {
                    SubmitVisit();   
                  }}>
                    <Text style={[styles.submitText,stylesFonts.semibold]}>Submit</Text>
                 </TouchableOpacity>
                </View>
        </View>
      </ScrollView>
      )}
    </KeyboardAwareScrollView>
    </View>
    <UploadPrescriptionScreen
        visible={modalVisible}
        onClose={() => setModalVisible(false)}
        onGallery={() => {
          console.log('Gallery Selected');
          setModalVisible(false);
          openGallery()
        }}
        onCamera={() => {
          setModalVisible(false);
          openCamera()
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
      borderColor: 'gray',
      borderRadius: 4,
      color: 'black',
      marginBottom: 20,
    },
    inputAndroid: {
      fontSize: 16,
      paddingVertical: 8,
      paddingHorizontal: 10,
      borderWidth: 1,
      borderColor: 'gray',
      borderRadius: 4,
      color: 'black',
      marginBottom: 20,
    },
  });