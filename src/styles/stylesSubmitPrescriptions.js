import { StyleSheet } from 'react-native';
import colors from '../utils/colors';

const stylesSubmitPrescriptions = StyleSheet.create({
    modalContainer: {
      flex:1,
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
        width:'100%',
        height: 200,
        backgroundColor:colors.white,
        resizeMode: 'cover',    // Options: 'contain', 'cover', 'stretch', 'center'
        borderRadius: 10,
        borderWidth: 1,
        borderColor: colors.primaryBorder,
      
      },
      columnStyle:{
        flexDirection: 'column',
      },
      rowContainer: {
        justifyContent: 'space-between',
      },
      sectionView:{
        paddingTop:'4',
        paddingBottom:'4',
      },
      filedText:{
        fontSize: 16,
        textAlign:'left',
        color: colors.primary,
      },
      textFiled: {
        borderColor: colors.gray,
        backgroundColor:colors.gray,
        tintColor:colors.black,
        borderWidth: 1,
        marginTop:10,
        marginBottom:10,
        paddingHorizontal: 20,
        borderRadius: 10,
        height:46,
        alignItems: 'left',
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
});

export default stylesSubmitPrescriptions;