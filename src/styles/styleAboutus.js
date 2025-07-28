import { StyleSheet } from 'react-native';
import colors from '../utils/colors';

const stylesAboutus = StyleSheet.create({
background: {
    flex: 1,
    backgroundColor: colors.white,
},
headerText: {
    fontSize: 20,
    color: colors.white,
},
content: {
    backgroundColor:colors.white,
    paddingHorizontal:10,
  },
containerView:{
    alignContent:'center',
    alignItems:'center',
    backgroundColor:colors.white,
},
sectionView:{
    alignItems:'center',
    paddingTop:'0',
    paddingBottom:'4',
  },
//   headerTitle:{    
//     alignItems:'left', 
//     paddingHorizontal:10,
//     paddingVertical: 20,
//   },
logoView:{
    width:160,
    height:160,
    paddingBottom:10,
    resizeMode: 'contain',
},
rowStyle:{
    flexDirection: 'row',
},
columnStyle:{
    flexDirection: 'column',
},
space:{
    paddingBottom:0,
},
space8:{
    marginTop:4,
    paddingBottom:4,
},
header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: colors.primary,
    paddingHorizontal: 15,
    paddingVertical: 10,
},
textLab:{
 color:colors.primary,
 fontSize:18,
},

textDr:{
    color:colors.black,
    fontSize:14,
    marginTop:4,
   },
textDesc:{
  color:colors.black,
  fontSize:14,
},
headerIcon: {
    width: 30,
    height: 30,
    // marginBottom: 10,
},
headerTitle: {
    justifyContent:'center',
    // alignSelf:'flex-start',
    fontSize: 18,
    color: colors.white,
},
webview: {
    flex: 1,
    height:"100%",
},
});

export default stylesAboutus;