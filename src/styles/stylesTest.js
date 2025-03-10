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
    padding: 8,
  },
  clearText: {
    width:22,
    height:22,
  },
  listContainer: {
    paddingHorizontal: 16,
  },
  testContainer: {
    flexDirection: 'row',
    alignItems: 'left',
    justifyContent: 'space-between',
    borderWidth: 1,
    borderColor: colors.primary,
    borderRadius: 8,
    padding: 16,
    marginBottom: 8,
  },
  testName: {
    flex: 1,
    color: colors.primary,
    flexWrap:'wrap',
    width:'70%',
    fontSize: 16,
  },
  priceContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginRight: 16,
  },
  priceSections:{
    flex:7,
    flexDirection: 'column',
    alignItems: 'left',
    flexWrap:'wrap',
    justifyContent: 'space-between',
    marginRight: 0,
  },
  price: {
    fontSize: 18,
    color: colors.black,
    marginRight: 8,
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
  removeButton: {
    backgroundColor: '#fff',
    borderWidth: 1,
    height:44,
    width:92,
    borderColor: colors.primary,
  },
  addButtonText: {
    color: colors.white,
    fontSize:12,
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