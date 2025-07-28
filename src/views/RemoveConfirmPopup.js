import React from "react";
import { View, Text, TouchableOpacity, StyleSheet } from "react-native";
import { Modal as RNModal } from "react-native"; // Import Modal as RNModal
import colors from "../utils/colors";

const RemoveItemModal = ({ visible, onClose, onConfirm }) => {
  return (
    <RNModal
      visible={visible} // Use 'visible' instead of 'isVisible'
      style={{ margin: 0 }} // Full screen
      transparent={true} // Enable transparency for backdrop effect
      animationType="fade" // Simple fade animation
      onRequestClose={onClose} // Triggered on hardware back press
    >
      <TouchableOpacity
        style={styles.modalContainer}
        activeOpacity={1} // Prevents visual feedback on press
        onPress={onClose} // Close modal when tapping outside
      >
        <View style={styles.modalContent}>
          <Text style={styles.title}>Healthcare 24x7</Text>
          <Text style={styles.message}>
            Do you want to remove this test/package from your cart?
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
      </TouchableOpacity>
    </RNModal>
  );
};

const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    justifyContent: "center", // Center content within the modal
    alignItems: "center",
    backgroundColor: "rgba(0, 0, 0, 0.4)", // Simulate backdrop with 40% opacity
  },
  modalContent: {
    width: "85%",
    backgroundColor: colors.white,
    borderRadius: 10,
    padding: 20,
    alignItems: "center",
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