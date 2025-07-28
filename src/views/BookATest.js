import React, { useState, useEffect, useRef } from 'react';
import { View, Text, TextInput, TouchableOpacity, SafeAreaView, Image, ActivityIndicator, FlatList, TouchableWithoutFeedback, Keyboard, KeyboardAvoidingView, Platform } from 'react-native';
import common from '../styles/commonStyle';
import styles from '../styles/stylesTest';
import images from '../utils/images';
import stylesFonts from '../styles/styleFonts';
import { api } from '../utils/ApiService/api';
import colors from '../utils/colors';
import { useCart } from '../context/CartContext';
import LoaderScreen from './LoaderScreen';
import { useFocusEffect } from '@react-navigation/native';
const TestList = ({ navigation }) => {
  const { state, dispatch } = useCart();
  const [reports, setReports] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [searchText, setSearchText] = React.useState('');
  const searchInputRef = useRef(null);

  const addToCart = (item) => {
    console.log("Add id:", item.ReportNo);
    dispatch({ type: 'ADD_ITEM', payload: item });
    console.log("Cart Product Add:", state.items);
  };

  const removeFromCart = (item) => {
    console.log("Remove id:", item.ReportNo);
    dispatch({ type: 'REMOVE_ITEM', payload: item });
    console.log("Cart Product Remove:", state.items);
  };

  const isItemInCart = (item) => {
    console.log("Cart List:", state.items);
    return state.items.some(cartItem =>
      cartItem.ReportNo === item.ReportNo
    );
  };

  useFocusEffect(
    React.useCallback(() => {
      const fetchReports = async () => {
        setLoading(true);
        try {
          const response = await api.get('/reportsinfo.php');
          console.log("API Response:", response.data.data);
          if (response.success === true) {
            setReports(response.data.data);
          } else {
            setError('Failed to fetch reports');
          }
        } catch (err) {
          setError(err.message);
        } finally {
          setLoading(false);
        }
      };
  
      fetchReports();
    }, [])
  );  

  useFocusEffect(
    React.useCallback(() => {
      setSearchText(''); // Reset search input when screen is focused
    }, [])
  );

  const filteredTests = (reports || []).filter((pkg) =>
    (pkg.ReportName || "").toLowerCase().includes((searchText || "").toLowerCase())
  );

  if (loading) {
    return <LoaderScreen visible={loading} />
  }

  if (error) {
    return <Text>Error: {error}</Text>;
  }

  const renderTests = ({ item }) => (
    <View style={[styles.testContainer, common.rowStyle]}>
      <View style={[styles.priceSections, common.columnStyle]}>
        <Text style={[styles.testName, stylesFonts.semibold]}>{item.ReportName}</Text>
        <Text style={[styles.price, stylesFonts.semibold]}>₹{item.ReportRate}</Text>
      </View>
      {isItemInCart(item) ? (
        <View style={styles.buttonView}>
          <TouchableOpacity
            style={[styles.addButton]}
            onPress={() => removeFromCart(item)}
          >
            <Text style={styles.addButtonText}>{"Remove"}</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <View style={styles.buttonView}>
          <TouchableOpacity
            style={[styles.addButton]}
            onPress={() => addToCart(item)}
          >
            <Text style={styles.addButtonText}>{"Add"}</Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
  );

  return (
      <SafeAreaView style={common.container}>
         <KeyboardAvoidingView
      style={{flex:1}}
      behavior={Platform.OS == 'ios' ? 'padding' : 'padding'}>
        <View style={styles.background}>
          {/* Header */}
          <View style={common.header}>
            <TouchableOpacity onPress={() => {
               Keyboard.dismiss(); // 👈 Close the keyboard first
               setTimeout(() => {
                 navigation.openDrawer(); // 👈 Slight delay to avoid UI glitch
               }, 100); // optional delay for smoother feel
            }}>
              <Image source={images.menu} style={styles.headerIcon} />
            </TouchableOpacity>
            <Text style={[styles.headerTitle, stylesFonts.bold]}>Book Test</Text>
            <TouchableOpacity onPress={() => navigation.navigate('MyCartView')} style={{ position: 'relative' }}>
              <Image source={images.cart} style={styles.headerIcon} />
              {state.items.length > 0 && (
                <View style={common.cartBadge}>
                  <Text style={common.cartBadgeText}>{state.items.length}</Text>
                </View>
              )}
            </TouchableOpacity>
          </View>

          <View style={styles.searchContainer}>
            <TextInput
              style={styles.searchInput}
              placeholder="Search Test"
              value={searchText}
              onChangeText={setSearchText}
            />
            <TouchableOpacity onPress={() => setSearchText('')}>
              <Image source={images.clearText} style={styles.clearText} />
            </TouchableOpacity>
          </View>

          {filteredTests.length === 0 ? (
            <View style={[common.columnStyle, styles.emptyView]}>
              <View style={[common.columnStyle, styles.emptySections]}>
                <Text style={styles.testName}>No test found.</Text>
              </View>
            </View>
          ) : (
            <FlatList
              data={filteredTests}
              keyExtractor={(item) => item.ReportNo.toString()}
              renderItem={renderTests}
              contentContainerStyle={styles.listContainer}
              keyboardShouldPersistTaps="handled" // Ensures touch events propagate while keyboard is open
            />
          )}
        </View>
        </KeyboardAvoidingView>
      </SafeAreaView>
  );
};

export default TestList;