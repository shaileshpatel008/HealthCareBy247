import { StyleSheet} from 'react-native';
import colors  from '../utils/colors'
import { Colors } from 'react-native/Libraries/NewAppScreen';
const stylesHomeScreen = StyleSheet.create({
    background:{
      flexDirection: 'column',
      flexGrow: 1,
      justifyContent: 'space-between',
      backgroundColor:colors.white,
    },
    menuIcon: {
      fontSize: 24,
      color: '#fff',
    },
    headerTitleGrid:{
      flexDirection: 'column',
      flexWrap: 'wrap',
      justifyContent: 'center',
      alignItems: 'center',
    },
    headerTitle: {
      fontSize: 18,
      color: '#fff',

    },
    headerSubTitle: {
      fontSize: 12,
      color: '#fff',
      
    },
    cartIcon: {
      fontSize: 24,
      color: '#fff',
    },
    gridContainer: { 
      flexDirection: 'row',
      flexWrap: 'wrap',
      justifyContent: 'space-between',
      padding: 33,
    },
    gridItem: {
      borderColor:"#3E409560",
      borderWidth:1,
      width: '46%',
      height: '44%',
      borderRadius: 15,
      justifyContent: 'center',
      alignItems: 'center',
      marginBottom: 10,
    },
    icon: {
      width: 60,
      height: 60,
      marginBottom: 15,
      resizeMode:'contain',
    },
    headerIcon: {
        width: 30,
        height: 30,
        marginBottom: 10,
      },
    gridText: {
      fontSize: 15,
      alignItems:'center',
      color: colors.primary,
    },
    uploadButton: {
      backgroundColor: '#4A90E2',
      padding: 15,
      marginHorizontal: 10,
      borderRadius: 8,
      alignItems: 'center',
    },
    uploadButtonText: {
      color: '#fff',
      fontSize: 16,
      fontWeight: 'bold',
    },
    image: {
      width: '100%',
      height: 200,
      elevation: 8,
    },
    card: {
      borderRadius: 20,
      overflow: 'hidden', // This ensures the image doesn't overflow beyond the rounded corners
      backgroundColor: '#fff', // Ensures a solid background for the shadow effect
      // ✅ iOS Shadow Properties
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 5 },
      shadowOpacity: 0.3,
      shadowRadius: 10,
  
      // ✅ Android Shadow Property
      elevation: 8,
    },
    itemText: {
      textAlign: 'center',
      fontSize: 20,
      fontWeight: 500,
    },
    content: {
      flex: 1,
    },
    carouselView:{
      overflow:'visible',
      marginTop:20,
      marginBottom:20,
      alignItems: 'center',
    },
    paginationContainer: {
      bottom: 10, // Position at the bottom
      left: 0,
      right: 0,
      alignItems: "center",
    },
    activeDotStyle: {
      backgroundColor: "#3E4095", 
      width: 20,
      height: 8,
      borderRadius: 25,
    },
    dotContainer: { gap: 5, marginTop: 0 },
    dotStyle: { backgroundColor: "#3E409520",  
      width: 10,
      height: 10,
      borderRadius: 5, // Regular dots as circles
      marginHorizontal: 0,},
  });
  export default stylesHomeScreen;