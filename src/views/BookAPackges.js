import React,{useState,useEffect} from 'react';
import { Modal,View, Text, TextInput, TouchableOpacity, FlatList,SafeAreaView,Image,ActivityIndicator } from 'react-native';
import common from '../styles/commonStyle';
import styles from '../styles/stylesPackage';
import images from '../utils/images';
import colors from '../utils/colors';
import stylesFonts from '../styles/styleFonts';
import PackagesDetailsScreen from './PackageDetails';
import { api } from '../utils/ApiService/api';
import { useCart } from '../context/CartContext'; // Adjust the path as necessary
import  LoaderScreen from './LoaderScreen';

const PackageList = ({ navigation }) => {
  const { state, dispatch} = useCart();
  const [modalVisible, setModalVisible] = useState(false);
  const [searchText, setSearchText] = React.useState('');
  const [packagesList, setPackages] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  

  const filteredPackages = packagesList.filter((pkg) =>
    pkg.Name.toLowerCase().includes(searchText.toLowerCase())
  );

  const handlePress = (id) => {
    setModalVisible(true)
  };
  const closeModal = () => {
    setModalVisible(false);
  };

  const addToCart = (item) => {
    console.log("Add id:",item.PackageId);
    dispatch({ type: 'ADD_ITEM', payload: item });
    console.log("Cart Product Add:",state.items);
  };

  const removeFromCart = (item) => {
    console.log("Remove id:",item.PackageId);
    dispatch({ type: 'REMOVE_ITEM', payload: item });
    console.log("Cart Product Remove:",state.items);
  };

  const isItemInCart = (item) => {
    console.log("Cart List:",state.items);
    return state.items.some(cartItem => 
      cartItem.PackageId === item.PackageId
    );
  };

  

  useEffect(() => {
      const fetchReports = async () => {
          try {
              const response = await api.get('/packageswithTest.php');
              if (response.success == true) {
                console.log("Test List:",response.data.data);
                  setPackages(response.data.data);
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
    }, []);

      if (loading) {
          return <LoaderScreen visible={loading} />
      }

      if (error) {
          return <Text>Error: {error}</Text>;
      }



  const renderPackage = ({ item }) => (
    <View style={[styles.packageContainer,styles.rowStyle]}>
      <View style={[styles.priceSections,styles.columnStyle]}>
      <Text style={[styles.packageName,stylesFonts.semibold]}>{item.Title}</Text>
      <View style={[styles.priceContainer,styles.rowStyle]}>
          <Text style={[styles.price,stylesFonts.semibold]}>₹{item.DiscountRate}</Text>
          <Text style={[styles.originalPrice,stylesFonts.semibold]}>₹{item.RoutingRate}</Text>
          <TouchableOpacity
             onPress={() => handlePress(item.id)}>
          <Image source={images.infoButton} style={styles.infobutton}/>
          </TouchableOpacity>
        </View>
      </View>

      {isItemInCart(item) ? (
              <TouchableOpacity
                style={[styles.addButton]}
                onPress={() => removeFromCart(item)}
                >
                  <Text style={styles.addButtonText}>{"Remove"}</Text>
                </TouchableOpacity>
            ) : (
              <TouchableOpacity
                style={[styles.addButton]}
                onPress={() => addToCart(item)}
                >
                <Text style={styles.addButtonText}>{"Add"}</Text>
              </TouchableOpacity>
            )}
    </View>
  );

  return (
    <SafeAreaView style={common.container}>
    <View style={styles.background}>
              {/* Header */}
      <View style={common.header}>
        <TouchableOpacity  onPress={() => navigation.openDrawer()}>
        <Image source={images.menu} style={styles.headerIcon} />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Book a Package</Text>
        <TouchableOpacity onPress={() => navigation.navigate('MyCartView')}>
        <Image source={images.cart} style={styles.headerIcon} />
        </TouchableOpacity>
      </View>

      <View style={styles.searchContainer}>
        <TextInput
          style={styles.searchInput}
          placeholder="Search Package"
          value={searchText}
          onChangeText={setSearchText}
        />
        <TouchableOpacity onPress={() => setSearchText('')}>
          <Image source={images.searchButton} style={styles.clearText} />
        </TouchableOpacity>
      </View>

      <FlatList
        data={filteredPackages}
        keyExtractor={(item) => item.PackageId.toString()}
        renderItem={renderPackage}
        contentContainerStyle={styles.listContainer}
      />
      
    </View>
    <Modal
        animationType="slide" // or "fade", "none"
        transparent={true}
        visible={modalVisible}
        onRequestClose={() => {closeModal}}>
        <PackagesDetailsScreen onClose={closeModal}/>
      </Modal>
    </SafeAreaView>
  );
};

export default PackageList;