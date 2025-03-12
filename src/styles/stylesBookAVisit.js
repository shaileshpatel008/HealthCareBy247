import { StyleSheet } from 'react-native';
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
    marginBottom: 10,
  },
  headerTitle: {
    fontSize: 18,
    color: colors.white,
  },
  containerView:{
    paddingTop:5,
    paddingEnd:15,
    paddingLeft:15,
    paddingRight:15,
  },
  rowStyle:{
    flexDirection: 'row',
  },
  columnStyle:{
    flexDirection: 'column',
  },
  rowContainer: {
    justifyContent: 'space-between',
  },
  sectionView:{
    paddingTop:'0',
    paddingBottom:'8',
  },
  fourmHeaderText: {
    fontSize: 16,
    textAlign:'center',
    color: colors.black,
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
  buttonUpload: {
    flexDirection: 'row',
    justifyContent:'center',
    alignItems: 'center',
    backgroundColor: colors.white,
    borderColor:colors.primary,
    paddingVertical: 12,
    borderWidth:1,
    paddingHorizontal: 20,
    height:50,
    borderRadius: 8,
    shadowColor: colors.black, // iOS shadow color
    shadowOffset: { width: 0, height: 4 }, // iOS shadow position
    shadowOpacity: 0.3, // iOS shadow transparency
    shadowRadius: 4, // iOS shadow blur
    elevation: 5,
  },
  buttonSubmit: {
    flexDirection: 'row',
    justifyContent:'center',
    alignItems: 'center',
    backgroundColor: colors.primary,
    paddingVertical: 12,
    paddingHorizontal: 20,
    height:50,
    borderRadius: 8,
    shadowColor: colors.black, // iOS shadow color
    shadowOffset: { width: 0, height: 4 }, // iOS shadow position
    shadowOpacity: 0.3, // iOS shadow transparency
    shadowRadius: 4, // iOS shadow blur
    elevation: 5,
  },
  icon: {
    marginRight: 8,
    width:24,
    height:24,
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
    flexBasis:'auto',
    justifyContent:'center',
    alignItems:'left',
  },
});

export default stylesPlaceInquery;