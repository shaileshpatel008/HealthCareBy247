
import React, { useState } from 'react';
import { View, Text, TouchableOpacity, Image, TextInput,Alert,ActivityIndicator } from 'react-native';
import Modal from 'react-native-modal';
import styles from '../styles/stylesSubmitPrescriptions';
import stylesFonts from '../styles/styleFonts';
import { api } from '../utils/ApiService/api';
import colors from '../utils/colors';

const SubmitPrescriptions = ({ visible, imageUri,onSubmit,onClose }) => {
        const [isLoading, setisLoading] = useState(false);
        const [name, setName] = useState('');
        const [mobilenumber, setMobileNumber] = useState('');

    const uploadImage = async () => {
      setisLoading(true)
    
      if (!imageUri || !name || !mobilenumber) {
        console.log("Please fill all fields and select an image");
        Alert.alert('Please fill all fields and select an image');
        return;
      }

      const timestamp = new Date().getTime();
      
      const formData = new FormData();
            formData.append('MobileNo', mobilenumber);
            formData.append('Name', name);      
            formData.append('Prescription', {
                    uri: imageUri, // Use the uri directly
                    type: 'image/jpeg', // Set the correct MIME type
                    name: `image_${timestamp}.jpg`, 
              });
      
      try {
        let response = await fetch("https://healthcare24x7.com/api/onlyPrescription.php", {
          method: "POST",
          body: formData,
          headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          },
        });
  
        let jsonResponse = await response.json();
        clearData();
        onSubmit("Upload successful!");
        setisLoading(false)
      } catch (error) {
        clearData();
        onSubmit("Upload failed!");
        setisLoading(false)
      }
    };

    const clearData = () => {
      setName('')
      setMobileNumber('')
    }
  return (
  <Modal    
      isVisible={visible} 
      style={{ margin: 0 }} // Full screen
      backdropOpacity={0.4} 
            onBackButtonPress={onClose}           
             >
    <View style={styles.modalContainer}>
      <View style={[styles.modalContent]}>
        <Image source={{ uri: imageUri }} style={styles.image}/>
    
        <View style={[styles.sectionView,styles.columnStyle]}>
            <Text style={[stylesFonts.semibold,styles.filedText]}>Name</Text>
            <TextInput
                    style={styles.textFiled}
                    placeholder="Enter Your Name"
                    value={name}
                    onChangeText={setName} // Updates state on text change
            />
        </View>

        <View style={[styles.sectionView,styles.columnStyle]}>
            <Text style={[stylesFonts.semibold,styles.filedText]}>Mobile Number</Text>
            <TextInput
                    style={styles.textFiled}
                    placeholder="Enter Your Mobile Number"
                    value={mobilenumber}
                    onChangeText={setMobileNumber} // Updates state on text change
            />
        </View>

        <TouchableOpacity style={[styles.button, styles.submitButton]} onPress={uploadImage}>
          { (isLoading) ? <ActivityIndicator size="small" color={colors.white}/>  : <Text style={[styles.submitButtonText]}>Upload</Text>}
        </TouchableOpacity>

        {/* ❌ Submit */}
        <TouchableOpacity style={[styles.button, styles.cancelButton]} onPress={onClose}>
          <Text style={[styles.cancelButtonText]}>Cancel</Text>
        </TouchableOpacity>
      </View>
      
    </View>
  </Modal>
  );
};


export default SubmitPrescriptions;