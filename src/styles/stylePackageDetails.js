import { StyleSheet } from 'react-native';
import colors from '../utils/colors';
const stylePackageDetails = StyleSheet.create({
    container: {
        flex: 1,
        alignItems:'center',
        justifyContent:'center',
        backgroundColor: colors.popupBackground,
    },
    header: {
      flexDirection: 'row',
      alignItems: 'center',
      justifyContent: 'space-between',
      backgroundColor: colors.white,
      paddingHorizontal: 15,
      paddingVertical: 10,
      height:65,
    },
    background: {
        borderRadius:12,
        width:'80%',
        height:'50%',
        overflow:'hidden',
        backgroundColor: colors.white,
      },
    headerText: {
      color: colors.primary,
      fontSize: 18,
    },
    headerIcon:{
      width: 24,
      height: 24,
      resizeMode:'contain',
    },
    doneButton: {
      padding: 10,
      borderRadius: 5,
    },
    doneButtonText: {
      color: colors.white,
      fontSize: 18,
    },
    packagesContainer: {
      padding: 10,
    },
    packageItem: {
      backgroundColor: colors.primary,
      padding: 15,
      marginVertical: 5,
      borderRadius: 5,
    },
    packageText: {
      fontSize: 16,
    },
    packageDetailsName: {
        fontSize: 16,
        fontWeight: 'normal',
        color: colors.primary,
        marginRight: 8,
        justifyContent:'flex-start',
      },
      packageDetailsContainer: {
        flexDirection: 'column',
        alignItems: 'left',
        justifyContent: 'space-between',
        marginBottom: 16,
      },
      listContainer: {
        paddingHorizontal: 16,
        paddingVertical: 16,
      },
  });
  export default stylePackageDetails;