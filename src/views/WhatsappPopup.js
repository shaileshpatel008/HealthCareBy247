import React, { useState } from 'react';
import { View, Text, Button, Modal as RNModal } from 'react-native';

const WhatsAppScreen = ({ navigation }) => {
    const [isModalVisible, setModalVisible] = useState(true);
  
    const closeModal = () => {
      setModalVisible(false);
      navigation.goBack(); // Go back to the previous tab
    };
  
    return (
      <View style={styles.screen}>
        <RNModal isVisible={isModalVisible}>
          <View style={styles.modalContent}>
            <Text style={styles.modalText}>WhatsApp Popup</Text>
            <Button title="Dismiss" onPress={closeModal} />
          </View>
        </RNModal>
      </View>
    );
  };

  export default WhatsAppScreen;
  