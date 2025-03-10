import { StyleSheet,Dimensions } from 'react-native';
import colors from '../utils/colors';

const stylesUploadPopup = StyleSheet.create({
    modalContainer: {
        flex:1,
        // backgroundColor: 'red',
        justifyContent: 'center',  // Center content within the modal
        alignItems: 'center', 
      },
      modalContent: {
        width: "80%",
        backgroundColor: colors.white,
        borderRadius: 10,
        padding: 20,
        alignItems: 'center',
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
        marginVertical: 5,
      },
      buttonText: {
        fontSize: 16,
        color: colors.primary,
      },
      cancelButton: {
        borderColor: colors.primaryBorder,
      },
});

export default stylesUploadPopup;