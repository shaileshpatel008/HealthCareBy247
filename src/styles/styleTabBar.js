import { StyleSheet } from 'react-native';
import colors from '../utils/colors';

const styles = StyleSheet.create({
    screen: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      backgroundColor: colors.primary, 
    },
    safeArea: {
      backgroundColor: colors.primary,
      marginBottom: 0, 
      borderTopLeftRadius:16,
      borderTopRightRadius: 16,
    },
    tabBarContainer: {
      flexDirection: 'row',
      backgroundColor: colors.primary,  // Dark blue background
      borderTopLeftRadius:16,
      borderTopRightRadius: 16,
      justifyContent: 'space-around',
      alignItems: 'center',
      paddingHorizontal: 5,
    },
    tabItem: {
      alignItems: 'center',
      flex: 1,
      paddingVertical: 8,
    },
    activeTab: {
      backgroundColor: colors.white, // White background for active tab
      borderRadius: 10,
      marginTop: 8,
      marginBottom: 8,
    },
    icon: {
      width: 24,
      height: 24,
      tintColor: colors.white,
    },
    activeIcon: {
      width: 24,
      height: 24,
      tintColor: colors.primary,
    },
    label: {
      color: colors.white,
      fontSize: 12,
      marginTop: 4,
    },
    activeLabel: {
      color: colors.primary, // Active label color
      fontWeight: 'bold',
    },
  });

  export default styles;