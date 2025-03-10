import React from "react";
import { View, Text, TouchableOpacity, StyleSheet } from "react-native";
import colors from "../utils/colors";
import Modal from 'react-native-modal';

const RemoveItemModal = ({ visible, onClose, onConfirm }) => {
  return (
    <Modal 
            isVisible={visible} 
            style={{ margin: 0 }} // Full screen
            backdropOpacity={0.4} 
            onBackButtonPress={onClose} 
          >
      <View style={styles.modalContainer}>
      <View style={styles.modalContent}>
        <Text style={styles.title}>Healthcare 24x7</Text>
        <Text style={styles.message}>
          Do you want to remove this item from your cart?
        </Text>
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={[styles.button, styles.yesButton]} onPress={onConfirm}>
            <Text style={styles.yesText}>Yes</Text>
          </TouchableOpacity>
          <TouchableOpacity style={[styles.button, styles.noButton]} onPress={onClose}>
            <Text style={styles.noText}>No</Text>
          </TouchableOpacity>
        </View>
        </View>
      </View>
    </Modal>
  );
};

const styles = StyleSheet.create({
  modalContainer: {
    flex:1,
    justifyContent: 'center',  // Center content within the modal
    alignItems: 'center', 
  },
  modalContent: {
    width: '85%',
    backgroundColor: colors.white,
    borderRadius: 10,
    padding: 20,
    alignItems: 'center',
  },
  title: {
    fontSize: 16,
    fontWeight: "bold",
    color: colors.primary,
    marginBottom: 10,
  },
  message: {
    fontSize: 14,
    textAlign: "center",
    marginBottom: 20,
    color: colors.black,
  },
  buttonContainer: {
    flexDirection: "row",
    justifyContent: "space-between",
    width: "100%",
  },
  button: {
    flex: 1,
    paddingVertical: 12,
    borderWidth: 1,
    borderRadius: 8,
    alignItems: "center",
    marginHorizontal: 5,
  },
  yesButton: {
    borderColor: colors.primaryBorder,
  },
  noButton: {
    borderColor: colors.primaryBorder,
  },
  yesText: {
    color: colors.primary,
    fontWeight: "bold",
  },
  noText: {
    color: colors.primary,
    fontWeight: "bold",
  },
});

export default RemoveItemModal;
