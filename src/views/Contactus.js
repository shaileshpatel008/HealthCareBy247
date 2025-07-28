import React, { useCallback, useEffect, useState } from 'react';
import { SafeAreaView, Image, View, Text, ActivityIndicator, TouchableOpacity, ScrollView, Linking, AppState } from 'react-native';
import images from '../utils/images';
import common from '../styles/commonStyle';
import stylesFonts from '../styles/styleFonts';
import styles from '../styles/styleContactus';
import { api } from '../utils/ApiService/api';
import colors from '../utils/colors';
import { useFocusEffect } from '@react-navigation/native';
import PromptBox from '../components/PromptBox';

const ContactUsScreen = ({ navigation }) => {
  const [expandedBranch, setExpandedBranch] = useState(null);
  const [branches, setBranches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [callPromptVisible, setCallPromptVisible] = useState(false); // New state for call prompt
  const [phoneNumberToCall, setPhoneNumberToCall] = useState(null); // Store the phone number to call

  useFocusEffect(
    useCallback(() => {
      setExpandedBranch(null); // Reset expandedBranch when the screen is focused
    }, [])
  );

  // Handle app state changes (to detect when the app comes back from the map)
  useEffect(() => {
    const subscription = AppState.addEventListener('change', (nextAppState) => {
      if (nextAppState === 'active') {
        setExpandedBranch(null); // Reset dropdown when returning from the map
      }
    });

    return () => subscription.remove(); // Cleanup the event listener
  }, []);

  const handleCall = (phoneNumber) => {
    setPhoneNumberToCall(phoneNumber); // Store the phone number
    setCallPromptVisible(true); // Show the custom prompt
  };

  const confirmCall = () => {
    const url = `tel:+91${phoneNumberToCall}`;
    Linking.openURL(url).catch((err) => Alert.alert('Error', 'Could not open dialer'));
    setCallPromptVisible(false); // Hide the prompt after action
  };

  const toggleBranch = (branchId) => {
    console.log("Branch ID:", branchId);
    setExpandedBranch(expandedBranch === branchId ? null : branchId);
  };

  useEffect(() => {
    const fetchBranches = async () => {
      try {
        const response = await api.get('/branches.php');
        if (response.data.status === 'success') {
          console.log(response.data.data);
          setBranches(response.data.data); // Set the branches data
        } else {
          setError('Failed to fetch branches');
        }
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchBranches();
  }, []);

  if (loading) {
    return (
      <View style={styles.background}>
        <ActivityIndicator size="large" color={colors.primary} />
      </View>
    );
  } else if (error) {
    return <Text>Error: {error}</Text>;
  }

  const openMap = (address) => {
    const formattedAddress = encodeURIComponent(address);
    const url = `https://www.google.com/maps/search/?api=1&query=${formattedAddress}`;
    Linking.openURL(url).catch((err) => Alert.alert('Error', 'Could not open maps'));
  };

  return (
    <SafeAreaView style={common.container}>
      <View style={styles.background}>
        {/* Header */}
        <View style={common.header}>
          <TouchableOpacity onPress={() => navigation.goBack()}>
            <Image source={images.back} style={styles.headerIcon} />
          </TouchableOpacity>
          <Text style={[styles.headerTitle, stylesFonts.bold]}>Contact Us</Text>
          <View style={styles.emptySpace} />
        </View>

        <ScrollView style={styles.content}>
          {/* Co-ordinator */}
          <View style={styles.section}>
            <Text style={[styles.sectionTitle, stylesFonts.bold]}>Co-ordinator</Text>
            <Text style={[styles.sectionContent, stylesFonts.medium]}>Dr. Hiral Bhavesh Faldu</Text>
          </View>

          {/* Our Branches */}
          <View style={styles.section}>
            <Text style={[styles.sectionTitle, stylesFonts.bold]}>Our Branches</Text>

            {branches.map(branch => (
              <View key={branch.BranchId} style={styles.branchContainer}>
                <TouchableOpacity
                  style={styles.branchHeader}
                  onPress={() => toggleBranch(branch.BranchId)}
                >
                  <View style={styles.branchHeaderLeft}>
                    <Image source={images.branchIcon} style={styles.branchIcon} />
                    <Text style={[styles.branchName, stylesFonts.bold]}>{branch.Name}</Text>
                  </View>
                  <Image
                    source={expandedBranch === branch.BranchId ? images.dropup : images.dropdown}
                    style={styles.branchIcon}
                  />
                </TouchableOpacity>

                {expandedBranch === branch.BranchId && (
                  <View style={styles.branchDetails}>
                    {/* Branch Address */}
                    <View style={styles.detailRow}>
                      <Image source={images.address} style={styles.detailsIcon} />
                      <Text style={[styles.detailText, stylesFonts.medium]}>Address:</Text>
                      <TouchableOpacity onPress={() => openMap(branch.Address)}>
                        <Image source={images.map} style={styles.detailsIcon} />
                      </TouchableOpacity>
                    </View>
                    <View style={styles.detailRow}>
                      <Text style={[styles.detailSubText, stylesFonts.regular]}>{branch.Address}</Text>
                    </View>
                    {/* Branch Mobile */}
                    <View style={styles.detailRow}>
                      <Image source={images.phone} style={styles.detailsIcon} />
                      <Text style={[styles.detailText, stylesFonts.medium]}>Mobile:</Text>
                    </View>
                    <View style={styles.detailRow}>
                      <TouchableOpacity onPress={() => handleCall(branch.ContactNo_1)}>
                        <Text style={[styles.detailSubText, stylesFonts.regular]}>{branch.ContactNo_1}</Text>
                      </TouchableOpacity>
                    </View>
                    {/* Branch Phone */}
                    <View style={styles.detailRow}>
                      <Image source={images.phone} style={styles.detailsIcon} />
                      <Text style={[styles.detailText, stylesFonts.medium]}>Phone:</Text>
                    </View>
                    <View style={styles.detailRow}>
                      <TouchableOpacity onPress={() => handleCall(branch.ContactNo_2)}>
                        <Text style={[styles.detailSubText, stylesFonts.regular]}>{branch.ContactNo_2}</Text>
                      </TouchableOpacity>
                    </View>
                  </View>
                )}
              </View>
            ))}
          </View>
        </ScrollView>
      </View>

      {/* Call Prompt Box */}
      <PromptBox
        visible={callPromptVisible}
        title="Initiate Call?" 
        description="Are you sure you want to call?"
        onCancel={() => {
          setCallPromptVisible(false);
          console.log("Call canceled");
        }}
        onConfirm={confirmCall}
      />
    </SafeAreaView>
  );
};

export default ContactUsScreen;