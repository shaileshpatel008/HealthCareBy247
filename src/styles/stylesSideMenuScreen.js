import { StyleSheet} from 'react-native';
import colors from '../utils/colors';
const stylesSideMenuScreen = StyleSheet.create({
  container: {
    width: "100%",
    flex: 1,
    borderTopRightRadius: 45,  
    backgroundColor: colors.white,
  },
  sideMenuDrawerView: {
    paddingTop: 0, marginTop: 0, padding: 0, margin: 0, flexGrow: 1
  },
  logo:{
    width:100,
    height:130,
    resizeMode: 'contain',
    marginBottom:0,
  },
  labName:{
    fontSize: 16,
    color: colors.primary,
  },
  email:{
    fontSize: 16,
    color: colors.primary,
  },
  header: {
    marginTop: 45,
    marginLeft: 20,
    marginRight: 20,
    marginBottom:10,
    backgroundColor: colors.white,
    alignItems: 'left',
  },
  headerSections:{
    flexDirection: "row",  // Arrange items in a row
    alignItems: 'flex-start',  // Align items vertically
    justifyContent: "space-between", // Space between image & icon
  },
  background: {
    width: "100%",
    height: "90%",
    backgroundColor: colors.primary,
  },
  menuItems: {
    marginTop: 0,
  },
  viewItem: {
    flexDirection: 'column',
    alignItems: 'left',
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    height:54,
    marginVertical: 0,
  },
  icon: {
    width:18,
    height:18,
    marginRight:10,
    color: colors.white,
    resizeMode: 'contain',
  },
  menuText: {
    fontSize: 18,    
    color: colors.white,
    fontFamily: "Poppins-SemiBold",
  },
});
  export default stylesSideMenuScreen;