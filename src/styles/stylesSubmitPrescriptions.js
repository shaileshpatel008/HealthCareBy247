import { StyleSheet } from 'react-native';
import colors from '../utils/colors';

const stylesSubmitPrescriptions = StyleSheet.create({
  modalContainer: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.4)',
    justifyContent: 'center',  // Center content within the modal
    alignItems: 'center',
  },
  modalContent: {
    width: '85%',
    backgroundColor: colors.white,
    borderRadius: 10,
    padding: 20,
    alignItems: 'left',
  },
  image: {
    width: '100%',
    height: 200,
    backgroundColor: colors.white,
    resizeMode: 'cover',    // Options: 'contain', 'cover', 'stretch', 'center'
    borderRadius: 10,
    borderWidth: 1,
    borderColor: colors.primaryBorder,

  },
  columnStyle: {
    // flexDirection: 'column',
  },
  rowContainer: {
    justifyContent: 'space-between',
  },
  sectionView: {
    paddingTop: '6',
    paddingBottom: '4',
    // backgroundColor:'red',
    width:'100%'
  },
  filedText: {
    marginTop:Platform.OS === 'ios' ? 10 :0,
    fontSize: 16,
    textAlign: 'left',
    color: colors.primary,
  },
  textFiled: {
    borderColor: colors.gray,
    backgroundColor: colors.gray,
    tintColor: colors.black,
    borderWidth: 1,
    marginTop: 10,
    marginBottom: 5,
    paddingHorizontal: 13,
    borderRadius: 10,
    height: 46,
    width:'220px',
    alignItems: 'left',
  },
  iosTextfield:{
    width:'220px'
  },

  modalTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: colors.primary,
  },
  modalSubtitle: {
    fontSize: 14,
    color: colors.primaryBorder,
    marginVertical: 8,
  },
  button: {
    width: '100%',
    padding: 12,
    backgroundColor: '#fff',
    borderRadius: 8,
    borderWidth: 1,
    borderColor: colors.primaryBorder,
    alignItems: 'center',
    marginBottom: 5,
    marginTop: 8
  },
  submitButtonText: {
    fontSize: 16,
    color: colors.white,
  },
  cancelButtonText: {
    fontSize: 16,
    color: colors.primary,
  },
  submitButton: {
    backgroundColor: colors.primary,
  },
  cancelButton: {
    borderColor: colors.primaryBorder,
  },
  errorText: {
    color: 'red',
    fontSize: 12,
    // marginTop: 2,
    marginLeft: 4
  },
  imagePreviewContainer: {
    flexDirection: 'row',
    marginTop: 10,
    
    width:'100%'
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
  buttonText: {
    color: colors.primary,
    fontSize: 18,
  },
  icon: {
    marginRight: 8,
    width: 24,
    height: 24,
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
    width:'100%'
    
  },
  deleteButton: {
    position: 'absolute',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    top: 5,
    right: 5,
    backgroundColor: 'red',
    width: 24,
    height: 24,
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
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'absolute',
    top: 40,
    right: 20,
    backgroundColor: 'red',
    // padding: 8,
    width: 28,
    height: 28,
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

export default stylesSubmitPrescriptions;