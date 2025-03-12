import { StyleSheet } from 'react-native';
import colors from '../utils/colors';
import { red } from 'react-native-reanimated/lib/typescript/Colors';

const stylesPackage = StyleSheet.create({

      background: {
        flex: 1,
        backgroundColor: colors.white,
      },

  headerText: {
    fontSize: 20,
    color: colors.white,
  },
  infobutton: {
    marginLeft:10,
    width:15,
    height:15,
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    margin: 16,
    borderWidth: 1,
    borderColor: colors.primaryBorder,
    height:46,
    borderRadius: 5,
    paddingHorizontal: 16,
  },
  searchInput: {
    flex: 1,
    padding: 0,
  },
  clearText: {
    width:22,
    height:22,
  },
  rowStyle:{
    flexDirection: 'row',
  },
  columnStyle:{
    flexDirection: 'column',
  },
  listContainer: {
    paddingHorizontal: 16,
  },
  emptyView: {
    flex: 1,
    alignContent:'center',
    justifyContent: 'center', // Center vertically
    alignItems: 'center', // Center horizontally
    padding: 20,
  },
  emptySections:{ 
    height:"60%",
    flexWrap:'wrap',
    alignItems:'center',
    justifyContent: 'space-between',
    marginRight: 0,
  },
  packageContainer: {
    width: '100%',  
    borderWidth: 1,  
    borderColor: colors.primary,
    borderRadius: 10,  
    padding: 10,  
    marginVertical: 10,  
    alignSelf: 'center', 
  },
  packageName: {
    fontSize: 16,
    color:colors.primary
  },
  priceContainer: {
    alignItems: 'center',
    justifyContent:'flex-start'
  },
  priceSections:{
    alignItems: 'flex-start',
    width: '70%',  
    padding:3,
  },
  price: {
    fontSize: 16,
    color: colors.black,
    marginRight: 4,
  },
  originalPrice: {
    fontSize: 14,
    textDecorationLine: 'line-through',
    color: colors.black,
  },
  button: {
    alignItems: 'center',  // Centers text horizontally
    justifyContent: 'center',
    paddingHorizontal: 16,
    borderRadius: 11,
    height:22,
  },
  addButton: {
    width:90,
    height:45,
    borderRadius:4,
    justifyContent:'center',
    backgroundColor: colors.primary,
  },
  buttonView:{
    margin:3,
    width: '30%',  
    alignItems:'flex-end',
  },
  addButtonText: {
    color: colors.white,
    fontSize:14,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: colors.primary,
    paddingHorizontal: 15,
    paddingVertical: 10,
  },
 headerIcon: {
    width: 30,
    height: 30,
    marginBottom: 10,
  },
  headerTitle: {
    fontSize: 18,
    color: colors.white,
  },
});

export default stylesPackage;