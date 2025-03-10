import React, { useState } from 'react';
import { Image, View, Text, TouchableOpacity,FlatList,SafeAreaView } from 'react-native';
import packageDetailsStyle from '../styles/stylePackageDetails';
import images from '../utils/images';
import common from '../styles/commonStyle';

const PackagesDetailsScreen = ({ onClose }) => {
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
      <Text style={packageDetailsStyle.packageDetailsName}>{item}</Text>
    </View>
  );

  return (
    <SafeAreaView style={packageDetailsStyle.container}>
        <View style={packageDetailsStyle.background }>
          <View style={packageDetailsStyle.header}>
            <Text style={packageDetailsStyle.headerText}>Cover Package Test </Text>
            <TouchableOpacity onPress={() => onClose()} style={packageDetailsStyle.doneButton}>
              <Image source={images.menuClose}/>
             </TouchableOpacity> 
           </View>
            <FlatList
            data={packages}
            keyExtractor={(item, index) => index.toString()} 
            renderItem={renderPackage}
            contentContainerStyle={packageDetailsStyle.listContainer}
            />
        </View>
    </SafeAreaView>
  );
};


export default PackagesDetailsScreen;