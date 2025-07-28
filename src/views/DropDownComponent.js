import React, { useState, useMemo, useCallback, useEffect, useRef } from 'react';
import {
  View,
  Text,
  Modal as RNModal,
  FlatList,
  TouchableOpacity,
  TextInput,
  StyleSheet,
  Dimensions,
  Image,
  Keyboard,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import colors from '../utils/colors';
import images from '../utils/images';

const { width, height } = Dimensions.get('window');

const DropdownComponent = React.memo(({
  data,
  isVisible,
  onClose,
  onSelect,
  isSearchEnabled = false,
  selectedValue,
  onPress,
  isClearable = false,
  placeholder = 'Select an item',
  isMultiSelect = false,
  customStyles = {},
  customButtonLabels = {},
  customIcons = {},
  dropdownHeight = height * 0.7,
  searchPlaceholder = 'Search...',
  loading = false,
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedItems, setSelectedItems] = useState([]);
  const [keyboardHeight, setKeyboardHeight] = useState(0);
  const [isSearchFocused, setIsSearchFocused] = useState(false);
  const searchInputRef = useRef(null);

  useEffect(() => {
    if (isMultiSelect && selectedValue) {
      const updatedItems = selectedValue.map(item => item);
      setSelectedItems(updatedItems);
    }

    // Listen to keyboard events
    const showSubscription = Keyboard.addListener('keyboardDidShow', (e) => {
      setKeyboardHeight(e.endCoordinates.height);
    });
    const hideSubscription = Keyboard.addListener('keyboardDidHide', () => {
      setKeyboardHeight(0);
      setIsSearchFocused(false); // Reset focus state when keyboard hides
    });

    return () => {
      showSubscription.remove();
      hideSubscription.remove();
    };
  }, [selectedValue, isMultiSelect]);

  const filteredData = useMemo(() => {
    return data.filter(item =>
      item.label?.toLowerCase().includes(searchQuery.toLowerCase())
    );
  }, [data, searchQuery]);

  const handleSelectItem = useCallback((item) => {
    if (isMultiSelect) {
      setSelectedItems(prevSelected => {
        const isSelected = prevSelected.some(selectedItem => selectedItem.value === item.value);
        const updatedSelection = isSelected
          ? prevSelected.filter(selectedItem => selectedItem.value !== item.value)
          : [...prevSelected, item];

        onSelect(updatedSelection);
        return updatedSelection;
      });
    } else {
      onSelect(item);
      onClose();
    }
  }, [onSelect, onClose, isMultiSelect]);

  const clearSearch = useCallback(() => setSearchQuery(''), []);

  const handleClearSelection = useCallback(() => {
    if (isMultiSelect) {
      setSelectedItems([]);
      onSelect([]);
    } else {
      setSelectedItems([]);
      onSelect({ value: '', label: '' });
    }
  }, [onSelect, isMultiSelect]);

  const renderItem = ({ item }) => {
    const isSelected = isMultiSelect
      ? selectedItems.some(selectedItem => selectedItem.value === item.value)
      : selectedValue?.value === item.value;

    return (
      <TouchableOpacity onPress={() => handleSelectItem(item)}>
        <View style={[styles.item, customStyles.item]}>
          <View style={[
            styles.circle,
            {
              backgroundColor: isSelected ? (customStyles.selectedColor || colors.primary) : 'white',
              borderColor: isSelected ? (customStyles.selectedColor || colors.primaryBorder) : 'gray',
            },
          ]} />
          <Text style={[styles.itemText, customStyles.itemText]}>{item.label}</Text>
        </View>
      </TouchableOpacity>
    );
  };

  const renderSelected = () => {
    if (isMultiSelect) {
      return selectedItems.length > 0 ? (
        <Text numberOfLines={1} style={[styles.multiselectText, customStyles.multiselectText]}>
          {selectedItems.map(item => item.label).join(', ')}
        </Text>
      ) : (
        <Text style={[styles.placeholderText, customStyles.placeholderText]}>
          {placeholder}
        </Text>
      );
    } else {
      return selectedValue?.value ? (
        <Text numberOfLines={1} style={[styles.selectedText, customStyles.selectedText]}>
          {selectedValue.label}
        </Text>
      ) : (
        <Text style={[styles.placeholderText, customStyles.placeholderText]}>
          {placeholder}
        </Text>
      );
    }
  };

  // Dynamic height calculation
  const dynamicHeight = isSearchFocused || keyboardHeight > 0
    ? dropdownHeight + (height * 0.2) // Increase height by 20% of screen height when focused
    : dropdownHeight;

  return (
    <TouchableOpacity
      disabled={isVisible}
      style={[styles.pickerWrapper, customStyles.pickerWrapper]}
      onPress={onPress}
    >
      <View style={[styles.contentWrapper, customStyles.contentWrapper]}>
        {isVisible ? (
          <View>
            <RNModal
              animationType="fade"
              transparent
              visible={isVisible}
              onRequestClose={onClose}
            >
              <KeyboardAvoidingView
                behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
                style={styles.modalContainer}
              >
                <View style={[styles.modalView, customStyles.modalView, { height: dynamicHeight - keyboardHeight }]}>
                  {isSearchEnabled && (
                    <View style={[styles.searchContainer, customStyles.searchContainer]}>
                      <TextInput
                        ref={searchInputRef}
                        placeholderTextColor="gray"
                        style={[styles.searchInput, customStyles.searchInput]}
                        placeholder={searchPlaceholder}
                        value={searchQuery}
                        onChangeText={setSearchQuery}
                        onFocus={() => setIsSearchFocused(true)}
                        onBlur={() => setIsSearchFocused(false)}
                      />
                      {searchQuery && (
                        <TouchableOpacity onPress={clearSearch} style={styles.clearButton}>
                          <Image source={images.close} size={20} color="red" />
                        </TouchableOpacity>
                      )}
                    </View>
                  )}
                  {loading ? (
                    <View style={styles.loadingContainer}>
                      <Image source={images.close} size={30} color="red" />
                    </View>
                  ) : (
                    <FlatList
                      keyboardShouldPersistTaps="handled"
                      data={filteredData}
                      ListEmptyComponent={() => (
                        <Text style={[styles.emptyListText, customStyles.emptyListText]}>
                          No data found!
                        </Text>
                      )}
                      keyExtractor={item => item.id || item.value}
                      renderItem={renderItem}
                      getItemLayout={(data, index) => ({
                        length: 50,
                        offset: 50 * index,
                        index,
                      })}
                    />
                  )}
                  <View style={styles.buttonContainer}>
                    <TouchableOpacity
                      style={[styles.button, { backgroundColor: 'gray' }, customStyles.closeButton]}
                      onPress={onClose}
                    >
                      <Text style={[styles.buttonText, customStyles.buttonText]}>
                        {customButtonLabels.close || 'Close'}
                      </Text>
                    </TouchableOpacity>
                    {(isMultiSelect ? selectedItems.length > 0 : selectedValue?.value) && (
                      <TouchableOpacity
                        style={[styles.button, { backgroundColor: colors.primary }, customStyles.submitButton]}
                        onPress={() => {
                          if (isMultiSelect) {
                            onSelect(selectedItems);
                          } else {
                            onSelect(selectedValue);
                          }
                          onClose();
                        }}
                      >
                        <Text style={[styles.buttonText, customStyles.buttonText]}>
                          {customButtonLabels.submit || 'Submit'}
                        </Text>
                      </TouchableOpacity>
                    )}
                  </View>
                </View>
              </KeyboardAvoidingView>
            </RNModal>
            {renderSelected()}
          </View>
        ) : (
          renderSelected()
        )}
      </View>
    </TouchableOpacity>
  );
});

const styles = StyleSheet.create({
  modalContainer: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
  },
  modalView: {
    marginHorizontal: 20,
    backgroundColor: colors.white,
    borderRadius: 10,
    padding: 10,
    elevation: 5,
  },
  contentWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    width: '100%',
  },
  pickerWrapper: {
    borderColor: colors.gray,
    backgroundColor: colors.gray,
    tintColor: colors.black,
    borderWidth: 1,
    marginTop: 8,
    marginBottom: 2,
    paddingHorizontal: 13,
    borderRadius: 10,
    height: 46,
    alignItems: 'left',
    justifyContent: 'center',
    width: '100%',
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: colors.gray,
    borderRadius: 10,
    paddingHorizontal: 10,
    marginBottom: 15,
  },
  searchInput: {
    flex: 1,
    height: 40,
    color: colors.black,
  },
  clearButton: {
    padding: 10,
  },
  item: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    paddingLeft: 10,
    marginVertical: 5,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: colors.primaryBorder,
  },
  circle: {
    width: 20,
    height: 20,
    borderRadius: 10,
    marginRight: 10,
    borderWidth: 2,
  },
  itemText: {
    color: colors.black,
  },
  emptyListText: {
    color: colors.danger,
    textAlign: 'center',
    paddingVertical: 10,
  },
  buttonContainer: {
    flexDirection: 'row',
    justifyContent: 'flex-end',
    gap: 10,
    marginTop: 15,
  },
  button: {
    padding: 10,
    borderRadius: 5,
    alignItems: 'center',
    width: width * 0.4,
  },
  buttonText: {
    color: colors.white,
    fontWeight: 'bold',
  },
  selectedText: {
    color: colors.black,
    fontSize: 14,
  },
  multiselectText: {
    flex: 0.90,
    color: colors.black,
    fontSize: 13,
  },
  placeholderText: {
    color: colors.primary,
    fontSize: 14,
  },
  clearIcon: {
    position: 'absolute',
    right: 0,
    padding: 5,
  },
  dropdownIcon: {
    position: 'absolute',
    right: 0,
    padding: 5,
  },
  loadingContainer: {
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
});

export default DropdownComponent;