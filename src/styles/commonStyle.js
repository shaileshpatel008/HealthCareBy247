import { StyleSheet} from 'react-native';
import colors  from '../utils/colors'

const stylesCommon = StyleSheet.create({
    container: {
      flex: 1,
      backgroundColor:colors.primary,
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: colors.primary,
        paddingHorizontal: 15,
        paddingVertical: 10,
        borderBottomLeftRadius:20,
        borderBottomRightRadius:20,
        height:65,
      },
      rowStyle:{
        flexDirection: 'row',
    },
    columnStyle:{
        flexDirection: 'column',
    },
})
export default stylesCommon;