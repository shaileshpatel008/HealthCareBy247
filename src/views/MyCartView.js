import React, { useState } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  FlatList,
  SafeAreaView,
  Image,
} from "react-native";
import useTestViewModel from "../viewmodels/TestViewModel";
import common from "../styles/commonStyle";
import styles from "../styles/stylesMyCart";
import images from "../utils/images";
import stylesFonts from "../styles/styleFonts";
import { useCart } from "../context/CartContext";
import RemoveItemModal from "./RemoveConfirmPopup";

const MyCartView = ({ navigation }) => {
  const { state, dispatch } = useCart();
  const [modalVisible, setModalVisible] = useState(false);
  const [itemRemove, setRemovedItem] = useState();

  const selectedPackageName = state.items
    .filter((item) => item.PackageId)
    .map((item) => ({
      label: item.Name,
      value: item.PackageId,
    }));
  const selectedTestName = state.items
    .filter((item) => item.ReportNo)
    .map((item) => ({
      label: item.ReportName,
      value: item.ReportNo,
    }));

  const placeInqueryFromCart = () => {
    navigation.navigate("PlaceInquery", {
      selectedPackageName,
      selectedTestName,
      clearname: "yes",
    });
  };
  const removePackageFromCart = (item) => {
    // console.log("Remove id:",item.ReportNo);
    dispatch({ type: "REMOVE_ITEM", payload: item });
    console.log("Cart Product Remove:", state.items);
  };

  const removePackageFromPackage = (item) => {
    console.log("Remove id:", item.ReportNo);
    dispatch({ type: "REMOVE_ITEM", payload: item });
    console.log("Cart Product Remove:", state.items);
  };
  const calculateTotalPrice = () => {
    return state.items.reduce((total, item) => {
      if (item.ReportRate) {
        return total + item.ReportRate; // Add report price
      } else if (item.RoutingRate) {
        return total + item.DiscountRate; // Add package price
      }
      return total; // Return total if no price found
    }, 0);
  };

  const renderTests = ({ item }) => {
    if (item.ReportNo) {
      return (
        <View style={[styles.packageContainer, common.rowStyle]}>
          <View style={[styles.pricePkgSections, common.columnStyle]}>
            <Text style={[styles.packageName, stylesFonts.semibold]}>
              {item.ReportName}
            </Text>
            <Text style={[styles.price, stylesFonts.semibold]}>
              ₹ {item.ReportRate}
            </Text>
          </View>
          {/* <View style={styles.buttonView}>
            <TouchableOpacity
              style={styles.rightCartView}
              // onPress={() => removePackageFromCart(item)}
            > */}
          {/* <Image source={images.removeCart} style={styles.removeCart} /> */}
          <View style={styles.deleteButtonView}>
            <TouchableOpacity
              style={[styles.deleteButton]}
              onPress={() => removePackageFromCart(item)}
            >
              <Text style={styles.deleteButtonText}>{"Delete"}</Text>
            </TouchableOpacity>
            {/* </View>
            </TouchableOpacity> */}
          </View>
        </View>
      );
    } else if (item.PackageId) {
      // Render for Packages
      return (
        <View style={[styles.packageContainer, common.rowStyle]}>
          <View style={[styles.pricePkgSections, common.columnStyle]}>
            <Text style={[styles.packageName, stylesFonts.semibold]}>
              {item.Title}
            </Text>
            <View style={[styles.priceContainer, common.rowStyle]}>
              <Text style={[styles.price, stylesFonts.semibold]}>
                ₹ {item.DiscountRate}
              </Text>
              <Text style={[styles.originalPrice, stylesFonts.semibold]}>
                ₹ {item.RoutingRate}
              </Text>
            </View>
          </View>
          <View style={styles.buttonView}>
            <TouchableOpacity
              style={styles.rightCartView}
              // onPress={() => removePackageFromCart(item)}
            >
              {/* <Image source={images.removeCart} style={styles.removeCart} /> */}
              <View style={styles.deleteButtonView}>
                <TouchableOpacity
                  style={[styles.deleteButton]}
                  onPress={() => removePackageFromCart(item)}
                >
                  <Text style={styles.deleteButtonText}>{"Delete"}</Text>
                </TouchableOpacity>
              </View>
            </TouchableOpacity>
          </View>
        </View>
      );
    }
  };

  return (
    <SafeAreaView style={common.container}>
      <View style={styles.background}>
        {/* Header */}
        <View style={common.header}>
          <TouchableOpacity onPress={() => navigation.goBack()}>
            <Image source={images.back} style={styles.headerIcon} />
          </TouchableOpacity>
          <Text style={[styles.headerTitle, stylesFonts.bold]}>My Cart</Text>
          <TouchableOpacity>
            <View source={images.cart} style={styles.headerBlank} />
          </TouchableOpacity>
        </View>
        {state.items.length === 0 ? (
          <View style={[common.columnStyle, styles.emptyCart]}>
            <View style={[common.columnStyle, styles.emptySections]}>
              <Image
                source={images.cartEmpty}
                style={styles.imageEmptyCart}
                resizeMode="cover"
              />
              {/* <Text style={styles.testName}>Select a package/test to continue.</Text> */}
              <View style={[common.rowStyle]}>
                <View style={styles.bookButtonView}>
                  <TouchableOpacity
                    style={[styles.bookButton]}
                    onPress={() => navigation.navigate("BookPackage")}
                  >
                    <Text style={styles.addButtonText}>{"Select Package"}</Text>
                  </TouchableOpacity>
                </View>
                <View style={styles.bookButtonView}>
                  <TouchableOpacity
                    style={[styles.bookButton]}
                    onPress={() => navigation.navigate("BookTest")}
                  >
                    <Text style={styles.addButtonText}>{"Select Test"}</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </View>
          </View>
        ) : (
          <FlatList
            data={state.items}
            // keyExtractor={(item, index) => item.id?.toString() || item.ReportNo?.toString() || item.PackageId?.toString() || index.toString()}
            keyExtractor={(item, index) => {
              return `${item.id || item.ReportNo || item.PackageId || "item"}-${index}`;
            }}
            renderItem={renderTests}
            contentContainerStyle={styles.listContainer}
          />
        )}
        {/* ReportRate,RoutingRate */}
        {/* Cart Place Inquery */}
        {state.items.length > 0 && (
          <View style={styles.footer}>
            <View style={[common.rowStyle, styles.cartSections]}>
              <View style={common.columnStyle}>
                <Text style={styles.TitleTotal}>Total</Text>
                <Text style={styles.TitlePrice}>₹ {calculateTotalPrice()}</Text>
              </View>
              <TouchableOpacity
                style={[styles.cartButton]}
                onPress={() => placeInqueryFromCart()}
              >
                <Text style={[styles.cartButtonText, stylesFonts.bold]}>
                  Place Inquiry
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        )}
      </View>
      {/* <View> */}
      <RemoveItemModal
        visible={modalVisible}
        onClose={() => {
          console.log("Popup close");
          setModalVisible(false);
        }}
        onConfirm={() => {
          // console.log("Popup Confirm:",item);
          setModalVisible(false);
          removePackageFromCart(itemRemove);
        }}
      />
      {/* </View> */}
    </SafeAreaView>
  );
};

export default MyCartView;
