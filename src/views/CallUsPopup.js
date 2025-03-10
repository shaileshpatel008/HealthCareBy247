import React, { useState } from 'react';
import { View, Text, Button } from 'react-native';

const CallUsScreen = ({ navigation }) => {
    const [isModalVisible, setModalVisible] = useState(true);
  
    const closeModal = () => {
      setModalVisible(false);
      navigation.goBack(); // Go back to the previous tab
    };
  
    return (
      <View style={styles.screen}>
        <Modal isVisible={isModalVisible}>
          <View style={styles.modalContent}>
            <Text style={styles.modalText}>Call Us Popup</Text>
            <Button title="Dismiss" onPress={closeModal} />
          </View>
        </Modal>
      </View>
    );
  };
  export default CallUsScreen;