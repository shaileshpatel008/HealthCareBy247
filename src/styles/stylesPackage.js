import { StyleSheet } from 'react-native';
import colors from '../utils/colors';

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
    width:30,
    height:30,
    padding:5,
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
  rowStyle:{
    flexDirection: 'row',
  },
  columnStyle:{
    flexDirection: 'column',
  },
  listContainer: {
    paddingHorizontal: 16,
  },
  packageContainer: {
    alignItems: 'left',
    justifyContent: 'space-between',
    borderWidth: 1,
    borderColor: colors.primary,
    borderRadius: 8,
    padding: 16,
    height:'90',
    marginBottom: 8,
  },
  packageName: {
    flex: 1,
    fontSize: 16,
    color:colors.primary
  },
  priceContainer: {
    alignItems: 'center',
    justifyContent: 'flex-start',

  },
  priceSections:{
    alignItems: 'left',
    flexWrap:'wrap',
    justifyContent: 'flex-start',
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
  addButtonText: {
    color: colors.white,
    fontSize:12,
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