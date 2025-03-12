import { StyleSheet } from 'react-native';
import colors from '../utils/colors';
const stylesTest = StyleSheet.create({

  background: {
    flex: 1,
    backgroundColor: colors.white,
  },

  headerText: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#fff',
  },
  cartIcon: {
    backgroundColor: '#fff',
    borderRadius: 20,
    padding: 8,
  },
  cartCount: {
    color: colors.primary,
    fontWeight: 'bold',
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
  listContainer: {
    paddingHorizontal: 16,
  },
  testContainer: {
    width: '100%',  
    borderWidth: 1,  
    borderColor: colors.primary,
    borderRadius: 10,  
    padding: 10,  
    marginVertical: 10,  
    alignSelf: 'center', 
  },
  testName: {
    color: colors.primary,
    flexWrap:'wrap',
    fontSize: 16,
  },
  priceContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 16,
  },
  priceSections:{
    alignItems: 'flex-start',
    width: '70%',  
    padding:3,
  },
  price: {
    fontSize: 18,
    color: colors.black,
    marginRight: 8,
  }, 
  buttonView:{
    margin:3,
    width: '30%',  
    alignItems:'flex-end',
  },
  button: {
    flex:2,
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
  removeButton: {
    backgroundColor: '#fff',
    borderWidth: 1,
    height:44,
    width:92,
    borderColor: colors.primary,
  },
  addButtonText: {
    color: colors.white,
    fontSize:14,
    fontWeight: 'bold',
    textAlign: 'center',
  },

 headerIcon: {
    width: 35,
    height: 35,
    marginBottom: 10,
  },
  headerTitle: {
    fontSize: 18,
    color: '#fff',
    fontWeight: 'bold',
  },
});

export default stylesTest;