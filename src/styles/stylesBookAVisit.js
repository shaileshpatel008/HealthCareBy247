import { StyleSheet,Platform } from 'react-native';
import colors from '../utils/colors';

const stylesPlaceInquery = StyleSheet.create({

  background: {
    flex: 1,
    backgroundColor: colors.white,
  },
  headerText: {
    fontSize: 20,
    color: colors.white,
  },
  hideIcon: {
    width: 35,
    height: 35,
    marginBottom: 10,
  },
  headerIcon: {
    width: 35,
    height: 35,
    // marginBottom: 10,
  },
  headerTitle: {
    fontSize: 18,
    color: colors.white,
  },
  containerView: {
    paddingTop: 5,
    paddingEnd: 9,
    paddingLeft: 9,
  },
  rowStyle: {
    flexDirection: 'row',
  },
  columnStyle: {
    flexDirection: 'column',
  },
  rowContainer: {
    justifyContent: 'space-between',
  },
  sectionView: {
    paddingTop: '8',
    paddingBottom: Platform.OS === 'ios' ? 11:8,
    width:'100%'
  },
  sectionViewLast: {
    paddingTop: '8',
    // paddingBottom: '8',
    width:'100%'
  },
  mainSectionView: {
    paddingTop: '8',
    paddingBottom: '8',
  },
  fourmHeaderText: {
    fontSize: 16,
    textAlign: 'center',
    color: colors.black,
  },
  filedText: {
    fontSize: 16,
    textAlign: 'left',
    color: colors.primary,
    marginLeft:4
  },
  textFiled: {
    borderColor: colors.gray,
    backgroundColor: colors.gray,
    tintColor: colors.black,
    borderWidth: 1,
    marginTop: 10,
    marginBottom: 2,
    paddingHorizontal: 13,
    borderRadius: 10,
    height: 46,
    alignItems: 'left',
    width:'100%'
  },
  buttonUpload: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderColor: colors.primary,
    paddingVertical: 12,
    borderWidth: 1,
    paddingHorizontal: 20,
    height: 50,
    borderRadius: 8,
    shadowColor: colors.black, // iOS shadow color
    shadowOffset: { width: 0, height: 4 }, // iOS shadow position
    shadowOpacity: 0.3, // iOS shadow transparency
    shadowRadius: 4, // iOS shadow blur
    elevation: 5,
  },
  buttonSubmit: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.primary,
    paddingVertical: 12,
    paddingHorizontal: 20,
    height: 50,
    borderRadius: 8,
    shadowColor: colors.black, // iOS shadow color
    shadowOffset: { width: 0, height: 4 }, // iOS shadow position
    shadowOpacity: 0.3, // iOS shadow transparency
    shadowRadius: 4, // iOS shadow blur
    elevation: 5,
  },
  icon: {
    marginRight: 8,
    width: 24,
    height: 24,
  },
  buttonText: {
    color: colors.primary,
    fontSize: 18,
  },
  submitText: {
    color: colors.white,
    fontSize: 18,
  },
  centerTouchble: {
    flexBasis: 'auto',
    justifyContent: 'center',
    alignItems: 'left',
  },


  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f8f9fa',
  },
  imagePreviewContainer: {
    flexDirection: 'row',
    marginTop: 10,
    marginBottom:Platform.OS == 'ios'?13:0
  },
  imageContainer: {
    position: 'relative',
    marginRight: 10,
  },
  imagePreview: {
    width: 100,
    height: 100,
    borderRadius: 8,
  },
  deleteButton: {
    position: 'absolute',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    top: 5,
    right: 5,
    backgroundColor: 'red',
    width: 22,
    height: 22,
    borderRadius: '50%',
    // padding: 3,
  },
  deleteText: {
    color: 'white',
    fontSize: 14,
    fontWeight: 'bold',
  },
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.5)',
  },
  modalButton: {
    backgroundColor: 'white',
    padding: 15,
    width: 200,
    alignItems: 'center',
    marginBottom: 10,
    borderRadius: 10,
  },
  modalText: {
    fontSize: 16,
    fontWeight: 'bold',
  },
  fullImageModal: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.9)',
  },
  closeModal: {
    display:'flex',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'absolute',
    top: 40,
    right: 20,
    backgroundColor: 'red',
    // padding: 8,
    width: 25,
    height: 25,
    borderRadius: '50%',
  },
  closeText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: 'black',
  },
  fullImage: {
    width: '90%',
    height: '80%',
    resizeMode: 'contain',
  },
  addMoreButton: {
    width: 100,  // Same as imagePreview width
    height: 100, // Same as imagePreview height
    backgroundColor: '#ddd', // Keep a neutral color
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 8, // Match the border radius of imagePreview
    marginLeft: 10,
  },
  addMoreText: {
    fontSize: 40, // Make the "+" icon bold and clear
    fontWeight: 'bold',
    color: '#000',
  },
  errorText: {
    color: 'red',
    fontSize: 12,
    // marginTop: 2,
    marginLeft: 4
  },

});

export default stylesPlaceInquery;