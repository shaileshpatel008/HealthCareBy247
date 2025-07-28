import React from 'react';
import { Modal as RNModal, View, Text, TouchableOpacity, StyleSheet } from 'react-native';

const PromptBox = ({ visible, title, description, onCancel, onConfirm }) => {
  return (
    <RNModal transparent visible={visible} animationType="fade">
      <View style={styles.overlay}>
        <View style={styles.box}>
          <Text style={styles.text}>{title}</Text>
          {description ? (
            <Text style={styles.description}>{description}</Text>
          ) : null}

          <View style={styles.buttonRow}>
            <TouchableOpacity onPress={onCancel} style={[styles.button, styles.leftButton]}>
              <Text style={styles.cancelText}>No</Text>
            </TouchableOpacity>
            <TouchableOpacity onPress={onConfirm} style={[styles.button, styles.rightButton]}>
              <Text style={styles.yesText}>Yes</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </RNModal>
  );
};

export default PromptBox;

const styles = StyleSheet.create({
  overlay: {
    flex: 1,
    backgroundColor: '#00000055',
    justifyContent: 'center',
    alignItems: 'center',
  },
  box: {
    width: 260,
    backgroundColor: '#fff',
    borderRadius: 15,
    paddingTop: 20,
    paddingBottom: 0,
    // paddingHorizontal: 20,
    alignItems: 'center',
  },
  text: {
    fontSize: 17,
    fontWeight: '500',
    color: '#333',
    textAlign: 'center',
    marginBottom: 10,
  },
  buttonRow: {
    flexDirection: 'row',
    borderTopWidth: 1,
    borderTopColor: '#ccc',
    width: '100%',
    height: 45,
  },
  button: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  leftButton: {
    borderRightWidth: 1,
    borderColor: '#ccc',
    borderBottomLeftRadius: 15,
  },
  rightButton: {
    borderBottomRightRadius: 15,
  },
  cancelText: {
    color: '#007aff',
    fontSize: 16,
    fontWeight: '600',
  },
  yesText: {
    color: '#007aff',
    fontSize: 16,
    fontWeight: '600',
  },
  description: {
    fontSize: 15,
    color: '#666',
    textAlign: 'center',
    marginHorizontal: 20,
    marginBottom: 20,
  },  
});
