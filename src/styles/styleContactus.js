
import { StyleSheet } from 'react-native';
import colors from '../utils/colors'

const stylesContactUs = StyleSheet.create({
  background: {
    flexDirection: 'column',
    flexGrow: 1,
    justifyContent: 'space-between',
    backgroundColor: colors.white,
  },
  menuIcon: {
    fontSize: 24,
    color: '#fff',
  },
  headerTitle: {
    // justifyContent:'center',
    // alignSelf:'flex-start',
    fontSize: 18,
    color: colors.white,
  },
  emptySpace: {
    width: 30, 
    height: 30,
  },
  headerIcon: {
    width: 30,
    height: 30,
    resizeMode: 'contain',
  },
  branchIcon: {
    width: 24,
    height: 24,
    resizeMode: 'contain',
  },
  content: {
    flex: 1,
    backgroundColor: colors.white,
    padding: 15,
  },
  section: {
    marginBottom: 5,
    backgroundColor: 'white',
    padding: 10,
    elevation: 2, // Shadow
  },
  sectionTitle: {
    fontSize: 16,
    marginBottom: 5,
    color: colors.primary,
  },
  sectionContent: {
    fontSize: 16,
    color: colors.black,
  },
  branchContainer: {
    marginTop: 15,
    marginBottom: 10,
    backgroundColor: 'white',
    borderColor: colors.primaryBorder,
    borderWidth: 1,
    borderRadius: 6,
    elevation: 2,
    shadowColor: colors.primaryBorder, // Shadow color
    shadowOffset: { width: 0, height: 2 }, // Shadow position offset
    shadowOpacity: 0.25, // Shadow opacity (0-1)
    shadowRadius: 3.84, // Shadow blur radius
  },
  branchHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    padding: 15,
  },
  branchHeaderLeft: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  branchName: {
    marginLeft: 10,
    fontSize: 16,
    color: colors.primary,
  },
  branchDetails: {
    padding: 15,
  },
  detailsIcon: {
    width: 24,
    height: 24,
    resizeMode: 'contain',
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
    flexWrap: 'wrap',
    justifyContent: 'flex-start',
    marginBottom: 4,
  },
  detailText: {
    flex: 1,
    alignItems: 'flex-start',
    textAlign: 'left',
    flexWrap: 'nowrap',
    marginLeft: 10,
    fontSize: 14,
    color: colors.primary,
  },
  detailSubText: {
    flex: 1,
    alignItems: 'flex-start',
    textAlign: 'left',
    flexWrap: 'nowrap',
    fontSize: 14,
    color: colors.black,
  },

});
export default stylesContactUs;