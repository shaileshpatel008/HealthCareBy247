import React, { useState } from 'react';
import { Image, View, Text, TouchableOpacity,FlatList,SafeAreaView } from 'react-native';
import packageDetailsStyle from '../styles/stylePackageDetails';
import images from '../utils/images';
import common from '../styles/commonStyle';
import stylePackageDetails from '../styles/stylePackageDetails';

const PackagesDetailsScreen = ({ packageInfo, onClose }) => {
  console.log(onClose)
  const [packages] = useState([
    '1. D DIMER',
    '2.FERRITIN',
    '3.CRP',
    '4.CBC',
    '5.ESR',
    '6.SGPT',
    '7.CREATININE',
    '8.LDH',
    '9.RBS'
  ]);

  const renderPackage = ({ item }) => (
    <View style={packageDetailsStyle.packageDetailsContainer}>
      <Text style={packageDetailsStyle.packageDetailsName}>{item.Name}</Text>
      {console.log(item)}
    </View>
  );

  return (
    <SafeAreaView style={packageDetailsStyle.container}>
        <View style={packageDetailsStyle.background }>
          <View style={packageDetailsStyle.header}>
            <Text style={packageDetailsStyle.headerText}>{packageInfo.Title}</Text>
            <TouchableOpacity onPress={() => onClose()} style={packageDetailsStyle.doneButton}>
              <Image source={images.menuClose} style={stylePackageDetails.headerIcon}/>
             </TouchableOpacity> 
           </View>
           <Text style={packageDetailsStyle.testTitle}>Following tests ate including in this pacakge.</Text>
           {packageInfo.Tests.length === 0 ? (
                <View style={[common.columnStyle,stylePackageDetails.emptyView]}>
                  <View style={[common.columnStyle,stylePackageDetails.emptySections]}>
                  <Text style={stylePackageDetails.packageDetailsName}>No found Tests.</Text>
                  </View>
                </View>
            ) : (
              <FlatList
                  data={packageInfo.Tests}
                  keyExtractor={(item, index) => index.toString()} 
                  renderItem={renderPackage}
                  contentContainerStyle={packageDetailsStyle.listContainer}
              />
            )}    
          
        </View>
    </SafeAreaView>
  );
};


export default PackagesDetailsScreen;