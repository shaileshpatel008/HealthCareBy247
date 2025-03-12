import React,{useState,useEffect} from 'react';
import { ScrollView,View, Text, TouchableOpacity, Image,Dimensions,SafeAreaView,Alert } from 'react-native';
import { useSharedValue, withTiming } from 'react-native-reanimated';
import Carousel, { Pagination } from 'react-native-reanimated-carousel';
import { launchCamera, launchImageLibrary } from 'react-native-image-picker';

//Files 
import common from '../styles/commonStyle';
import stylesFonts from '../styles/styleFonts';
import colors from '../utils/colors';
import images from '../utils/images';
import styles from '../styles/styleHome';
import SubmitPrescriptions from '../views/SubmitPrescriptions';
import UploadPrescriptionScreen from './UploadPrescriptions';
import { api } from '../utils/ApiService/api';


const width = Dimensions.get('window').width;

const HomeScreen = ({ navigation }) => {
 const [bannerList, setBanner] = useState([]);
 const [modalVisible, setModalVisible] = useState(false);
 const [modalSubmit, setModalSubmit] = useState(false);
 const [imageUri, setImageUri] = useState(null);

 const imagesData = bannerList.map(obj => obj.preview_url);

 const fetchBanner = async () => {
        try {
            const response = await api.get('/newsletter.php');
            if (response.success == true) {
              console.log("Banner List:",response.data.data);
              setBanner(response.data.data);
            } else {
                setError('Failed to fetch reports');
            }
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };


  // 📷 Open Camera
  const openCamera = () => {
    const options = {
      mediaType: 'photo',
      quality: 0.5,
      saveToPhotos: true,
    };

    launchCamera(options, (response) => {
      if (response.didCancel) {
        Alert.alert('User cancelled camera');
      } else if (response.errorMessage) {
        Alert.alert('Camera Error:', response.errorMessage);
      } else {
        setImageUri(response.assets[0].uri);
        setModalSubmit(true);
      }
    });
  };

  // 📂 Open Gallery
  const openGallery = () => {
    const options = {
      mediaType: 'photo',
      quality: 0.5,
    };

    launchImageLibrary(options, (response) => {
      if (response.didCancel) {
        Alert.alert('User cancelled gallery');
      } else if (response.errorMessage) {
        Alert.alert('Gallery Error:', response.errorMessage);
      } else {
        setImageUri(response.assets[0].uri);
        setModalSubmit(true);
      }
    });
  };


  const progress = useSharedValue(0);
  const renderItem = ({ item }) => (
    <View style={styles.card}>
      <Image source={{ uri: item }} style={styles.image} />
    </View>
  );

    // Fetch data when component mounts
    useEffect(() => {
        fetchBanner();
      }, []);

  return (
    <SafeAreaView style={common.container}>
      <View style={styles.background}>
        {/* Header */}
        <View style={common.header}>
          <TouchableOpacity  onPress={() => navigation.openDrawer()}>
          <Image source={images.menu} style={styles.headerIcon} />
          </TouchableOpacity>
          <View style={styles.headerTitleGrid}>
          <Text style={[styles.headerTitle,stylesFonts.bold]}>Healthcare 24x7 Lab</Text>
          <Text style={[styles.headerSubTitle,stylesFonts.medium]}>Ahmedabad</Text>
          </View>
          <TouchableOpacity onPress={() => navigation.navigate('MyCartView')}>
          <Image source={images.cart} style={styles.headerIcon} />
          </TouchableOpacity>
        </View>
        <ScrollView style={styles.content}>
        {/* Carousal Slider*/}
        <View style={styles.carouselView}>
          <Carousel
              width={width * 0.9} // Width of each carousel item
              height={width * 0.51} // Height of each carousel item
              data={imagesData} // Array of image URLs
              renderItem={renderItem}
              loop={true} // Enables infinite scrolling
              autoPlay={true} // Enables auto-play
              autoPlayInterval={3000} // Auto-play interval (3 seconds)
              onProgressChange={(_, absoluteProgress) => {
                progress.value = absoluteProgress; // Update progress
              }}
            />
        </View>
        {/* Paggination Dot*/}
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
            <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]}  onPress={() =>  navigation.navigate('BookPackage')} >
              <Image source={images.homeBookAPakage} style={styles.icon} />
              <Text style={[styles.gridText,stylesFonts.semibold]}>Book a Package</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]} onPress={() =>  navigation.navigate('BookTest')}>
              <Image source={images.homeBookATest} style={styles.icon} />
              <Text style={[styles.gridText,stylesFonts.semibold]}>Book a Test</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]} onPress={() =>  navigation.navigate('BookAVisit')}>
              <Image source={images.homeBookVisit} style={styles.icon} />
              <Text style={[styles.gridText,stylesFonts.semibold]}>Book a Visit</Text>
            </TouchableOpacity>
            <TouchableOpacity style={[styles.gridItem, { backgroundColor: colors.white }]} onPress={() =>  setModalVisible(true)}>
              <Image source={images.homeUploadPrescription} style={styles.icon} />
              <Text style={[styles.gridText,stylesFonts.semibold]}>Upload Prescription</Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
        </View>
        <View>
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
        </View>
      <View>
        
    <SubmitPrescriptions
        visible={modalSubmit}
        imageUri={imageUri}
        onSubmit={(message) => {
          console.log('Submit fourm Selected');
          setModalSubmit(false);
          Alert.alert('Healthcare 24x7 Lab', message);
        }}
        onClose= {() =>{
          setModalSubmit(false);
        }}
      />  
      </View>
      </SafeAreaView>
  );
};

export default HomeScreen;