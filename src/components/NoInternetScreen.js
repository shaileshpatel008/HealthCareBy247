import React, { useEffect } from 'react';
import { View, Text, StyleSheet, Image } from 'react-native';
import NetInfo from '@react-native-community/netinfo';
import useNetworkStatus from '../utils/useNetworkStatus';
import colors from '../utils/colors';
import images from '../utils/images';

const NoInternetScreen = ({ onReconnect }) => {
    const isConnected = useNetworkStatus();

    useEffect(() => {
        if (isConnected && onReconnect) {
            onReconnect(); // Auto-dismiss screen or refetch
        }
    }, [isConnected]);

    return (
        <View style={styles.container}>
            <Image source={images.noInternet} style={styles.icon} />
            <Text style={styles.text}>No Internet Connection</Text>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        backgroundColor: colors.white,
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center'
    },
    text: {
        fontSize: 18,
        color: 'gray'
    },
    icon: {
        width: 100,
        height: 100,
        // marginBottom: 20,
    },
});

export default NoInternetScreen;
