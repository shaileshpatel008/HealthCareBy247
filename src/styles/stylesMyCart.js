import { StyleSheet } from 'react-native';
import colors from '../utils/colors';

const stylesMyCart = StyleSheet.create({

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
    height: 46,
    borderRadius: 5,
    paddingHorizontal: 16,
  },
  searchInput: {
    flex: 1,
    padding: 8,
  },
  removeCart: {
    width: 22,
    height: 22,
    resizeMode: 'cover',
  },
  listContainer: {
    paddingVertical: 16,
    paddingHorizontal: 16,
  },
  emptyCart: {
    flex: 1,
    alignContent: 'center',
    justifyContent: 'center', // Center vertically
    alignItems: 'center', // Center horizontally
    padding: 20,
    // position: 'relative', // Position relative for absolute positioning of text

  },
  imageEmptyCart: {
    width: 200, // Set your desired width
    height: 200, // Set your desired height
    resizeMode: 'center',
    // marginBottom: 10, 
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
    flexWrap: 'wrap',
    fontSize: 16,
  },
  priceContainer: {
    alignItems: 'center',
    justifyContent: 'flex-start',
  },
  priceSections: {
    flex: 7,
    flexDirection: 'column',
    alignItems: 'left',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    marginRight: 0,
  },
  packageName: {
    flex: 1,
    width: '100%',
    fontSize: 16,
    color: colors.primary
  },
  pricePkgSections: {
    alignItems: 'flex-start',
    width: '70%',
    padding: 3,
  },
  packageContainer: {
    width: '100%',
    borderWidth: 1,
    borderColor: colors.primary,
    borderRadius: 10,
    padding: 10,
    marginVertical: 10,
    alignSelf: 'center',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center'
  },
  infobutton: {
    marginLeft: 10,
    width: 30,
    height: 30,
    padding: 5,
  },
  originalPrice: {
    fontSize: 14,
    textDecorationLine: 'line-through',
    color: colors.black,
  },
  buttonView: {
    margin: 3,
    width: '30%',
    justifyContent: 'flex-start',
  },
  deleteButtonView: {
    margin: 3,
    width: '30%',
    alignItems: 'flex-end',
  },
  // deleteButton: {
  //   width: 90,
  //   height: 45,
  //   borderRadius: 4,
  //   justifyContent: 'center',
  //   backgroundColor: colors.danger,
  // },
   deleteButton: {
    width: 80,
    height: 35,
    borderRadius: 12, // Fully rounded edges
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.danger,
  },  
  // deleteButton: {
  //   width: 80,
  //   height: 45,
  //   borderRadius: 8,
  //   justifyContent: 'center',
  //   alignItems: 'center',
  //   backgroundColor: colors.danger,
  //   borderWidth: 2,
  //   borderColor: colors.white, // White border
  // },
  // deleteButton: {
  //   width: 90,
  //   height: 45,
  //   borderRadius: 25, // Smooth pill shape
  //   justifyContent: 'center',
  //   alignItems: 'center',
  //   backgroundColor: colors.danger,
  // },  
  // deleteButton: {
  //   width: 100,
  //   height: 45,
  //   borderRadius: 10,
  //   justifyContent: 'center',
  //   alignItems: 'center',
  //   backgroundColor: colors.danger,
  //   borderWidth: 1,
  //   borderColor: 'rgba(255, 255, 255, 0.3)',
  // },    
  // deleteButton: {
  //   width: 100,
  //   height: 45,
  //   borderRadius: 8,
  //   justifyContent: 'center',
  //   alignItems: 'center',
  //   backgroundColor: colors.danger,
  //   shadowColor: '#000',
  //   shadowOffset: { width: 3, height: 3 },
  //   shadowOpacity: 0.5,
  //   shadowRadius: 3,
  //   elevation: 6,
  // },  
  deleteButtonText: {
    color: colors.white,
    fontSize: 14,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  bookButtonView: {
    margin: 3,
    width: '40%',
    justifyContent: 'flex-start',
  },
  rightCartView: {
    alignItems: 'flex-end',
  },
  price: {
    fontSize: 16,
    color: colors.black,
    marginRight: 8,
  },
  button: {
    alignItems: 'center',  // Centers text horizontally
    justifyContent: 'center',
    paddingHorizontal: 16,
    borderRadius: 11,
    height: 22,
  },
  bookButton: {
    width: 120,
    marginRight: 10,
    height: 45,
    borderRadius: 4,
    justifyContent: 'center',
    backgroundColor: colors.primary,
  },
  addButton: {
    width: 90,
    height: 45,
    borderRadius: 4,
    justifyContent: 'center',
    backgroundColor: colors.primary,
  },
  removeButton: {
    backgroundColor: '#fff',
    borderWidth: 1,
    height: 44,
    width: 92,
    borderColor: colors.primary,
  },
  addButtonText: {
    color: colors.white,
    fontSize: 12,
    fontWeight: 'bold',
    textAlign: 'center',
  },
  footer: {
    height: 86,
    borderTopLeftRadius: 18,
    borderTopRightRadius: 18,
    padding: 20,
    backgroundColor: colors.primary,
    borderTopWidth: 1,
    borderTopColor: colors.primaryBorder,
  },
  headerIcon: {
    width: 35,
    height: 35,
  },
  headerBlank: {
    width: 35,
    height: 35,
  },
  headerTitle: {
    fontSize: 18,
    color: '#fff',
    // fontWeight: 'bold',
  },
  TitleTotal: {
    fontSize: 18,
    color: '#fff',
    fontWeight: 'bold',
  },
  TitlePrice: {
    fontSize: 20,
    color: '#fff',
    fontWeight: 'bold',
  },
  emptySections: {
    height: "50%",
    flexWrap: 'wrap',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginRight: 0,
  },
  cartSections: {
    alignItems: 'left',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    marginRight: 0,
  },
  cartButton: {
    width: '50%',
    height: 56,
    borderRadius: 8,
    justifyContent: 'center',
    backgroundColor: colors.white,
  },
  cartButtonText: {
    color: colors.primary,
    fontSize: 18,
    textAlign: 'center',
  },
});

export default stylesMyCart;