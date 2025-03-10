
import React, { useState } from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import Modal from 'react-native-modal';
import styles from '../styles/stylesUploadPrescriptions';


const UploadPrescriptionScreen = ({ visible, onClose, onGallery, onCamera }) => {
  
  return (
    <Modal    
        isVisible={visible} 
        style={{ margin: 0 }} // Full screen
        backdropOpacity={0.4} 
        onBackButtonPress={onClose}         
         >
    <View style={styles.modalContainer}>
      <View style={styles.modalContent}>
        <Text style={styles.modalTitle}>Healthcare 24x7 Lab</Text>
        <Text style={styles.modalSubtitle}>Select Photo Option</Text>

        {/* 📂 Choose From Gallery */}
        <TouchableOpacity style={styles.button} onPress={onGallery}>
          <Text style={styles.buttonText}>Choose From Photo Gallery</Text>
        </TouchableOpacity>

        {/* 📷 Take Photo */}
        <TouchableOpacity style={styles.button} onPress={onCamera}>
          <Text style={styles.buttonText}>Take Photo</Text>
        </TouchableOpacity>

        {/* ❌ Cancel */}
        <TouchableOpacity style={[styles.button, styles.cancelButton]} onPress={onClose}>
          <Text style={[styles.buttonText]}>Cancel</Text>
        </TouchableOpacity>
      </View>
    </View>
  </Modal>
  );
};


export default UploadPrescriptionScreen;