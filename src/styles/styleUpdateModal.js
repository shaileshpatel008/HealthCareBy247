import { StyleSheet } from 'react-native';

export default StyleSheet.create({
    modalOverlay: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.4)',
        justifyContent: 'flex-end',
    },
    modalContainer: {
        backgroundColor: 'white',
        paddingTop: 15,
        paddingHorizontal: 20,
        paddingBottom: 20,
        borderTopLeftRadius: 20,
        borderTopRightRadius: 20,
        width: '100%',
        elevation: 10,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: -2 },
        shadowOpacity: 0.3,
        shadowRadius: 4,
    },
    header: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: 25,
    },
    headerLeft: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    googlePlayIcon: {
        width: 20,
        height: 20,
        resizeMode: 'contain',
        marginRight: 8,
    },
    googlePlayText: {
        fontSize: 16,
        fontWeight: 'semibold',
    },
    closeIcon: {
        width: 20,
        height: 20,
    },
    title: {
        fontSize: 18,
        fontWeight: 'bold',
        marginBottom: 15,
    },
    description: {
        marginBottom: 15,
    },
    appInfo: {
        flexDirection: 'row',
        alignItems: 'center',
        marginBottom: 15,
    },
    appLogo: {
        width: 40,
        height: 50,
        resizeMode: 'contain',
        marginRight: 7,
    },
    appName: {
        fontSize: 16,
        fontWeight: 'semibold',
    },
    appRated: {
        color: 'gray',
    },

    whatsNewRow: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginBottom: 1,
    },
    whatsNewTitle: {
        fontSize: 16,
        fontWeight: 'semibold',
    },
    lastUpdatedText: {
        color: 'gray',
    },
    arrowIcon: {
        width: 12,
        height: 12,
        resizeMode: 'contain',
    },
    
    buttonContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        marginTop: 25,
        gap: 10, // space between buttons
    },

    learnMoreButton: {
        height: 40,
        width: 150,
        borderColor: '#1a73e8',
        borderWidth: 1,
        borderRadius: 20,
        backgroundColor: 'white',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center'
    },

    learnMoreText: {
        color: '#1a73e8',
        fontWeight: 'bold',
    },

    updateButton: {
        height: 40,
        width: 150,
        backgroundColor: '#1a73e8',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 20,
    },

    updateButtonText: {
        color: 'white',
        fontWeight: 'bold',
    },
});
