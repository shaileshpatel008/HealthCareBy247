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
    paddingBottom:'10',
  },
  headerTitle:{
    alignItems:'left', 
    paddingHorizontal:10,
    paddingVertical: 20,
  },
logoView:{
    width:160,
    height:160,
    paddingBottom:10,
},
rowStyle:{
    flexDirection: 'row',
},
columnStyle:{
    flexDirection: 'column',
},
space:{
    paddingBottom:10,
},
space8:{
    paddingBottom:10,
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
    fontSize:16,
   },
headerIcon: {
    width: 30,
    height: 30,
    marginBottom: 10,
},
headerTitle: {
    fontSize: 18,
    color: colors.white,
    marginBottom: 15,
},
});

export default stylesAboutus;