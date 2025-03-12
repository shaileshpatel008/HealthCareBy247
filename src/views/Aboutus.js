import React,{Fragment} from 'react';
import { View, Text, TouchableOpacity,SafeAreaView,Image } from 'react-native';
import usePackageViewModel from '../viewmodels/PackageViewModel';
import common from '../styles/commonStyle';
import styles from '../styles/styleAboutus';
import images from '../utils/images';

import stylesFonts from '../styles/styleFonts';
import { ScrollView } from 'react-native-gesture-handler';


const Aboutus = ({ navigation }) => {

  

  return (
    <SafeAreaView style={common.container}>
      <View style={[styles.background, styles.columnStyle]}>
        {/* Header */}
        <View style={common.header}>
          <TouchableOpacity onPress={() => navigation.openDrawer()}>
            <Image source={images.menu} style={styles.headerIcon} />
          </TouchableOpacity>
          <Text style={styles.headerTitle}>About Us</Text>
          <TouchableOpacity>
            <Image source={images.cart} style={styles.headerIcon} />
          </TouchableOpacity>
        </View>
        {/* Logo Sections */}
        <ScrollView style={styles.content}>
          <View style={[styles.sectionView, styles.columnStyle, styles.space]}>
            <Image source={images.logo} style={styles.logoView}></Image>
            <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>HEALTH CARE 24x7 </Text>
            <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>PATHOLOGY & ENDOCRINE </Text>
            <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>LABORATORY</Text>
          </View>
          <View style={styles.headerTitle}>
            <Text style={[styles.space8, styles.textLab, stylesFonts.bold]}>About Us</Text>
            <View style={[styles.headerTitle,styles.space8, styles.rowStyle]}>
              <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>Co-ordinator:</Text>
              <Text style={[styles.space, styles.textDr, stylesFonts.bold]}>  Dr. Hiral Bhavesh Faldu</Text>
            </View>
            <Text style={[styles.space, styles.textDesc, stylesFonts.regular]}>HEALTH CARE 24x7 PATHOLOGY & ENDOCRINE LABORATORY is a fully automated and computerized pathology laboratory equipped with the latest and most modern technologies. We are committed to providing comprehensive, high-quality, and rapid-response laboratory testing at affordable prices. Our advanced technologies enable accurate diagnosis and treatment of various diseases, catering to physicians, nursing homes, companies, and institutions in Ahmedabad.</Text>
          </View>

          <View style={[styles.headerTitle,styles.space8, styles.columnStyle]}>
            <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>Our Strategy</Text>
            <Text style={[styles.space, styles.textDesc, stylesFonts.regular]}>Since our inception, we have continuously adopted the latest advancements in laboratory testing, ensuring we offer the most cutting-edge diagnostic capabilities. Our goal is to provide 100% certified results with high precision and fast turnaround times. We strive to improve our services, making ourselves a valuable partner for clinicians and other medical professionals.</Text>
          </View>


          <View style={[styles.headerTitle,styles.space8, styles.columnStyle]}>
            <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>Our Vision</Text>
            <Text style={[styles.space, styles.textDesc, stylesFonts.regular]}>To become a leading pathology laboratory for comprehensive diagnostic services.</Text>
          </View>

          <View style={[styles.headerTitle, styles.space8,styles.columnStyle]}>
            <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>Our Mission</Text>
            <Fragment>
              <Text style={[styles.space, styles.textDesc, stylesFonts.regular]}>• To deliver accurate and precise diagnostic, prognostic, and predictive testing services promptly.</Text>
              <Text style={[styles.space, styles.textDesc, stylesFonts.regular]}>• To ensure patients and doctors trust us by maintaining high-quality standards.</Text>
              <Text style={[styles.space, styles.textDesc, stylesFonts.regular]}>• To act with integrity and commitment, always putting patients first.</Text>
              <Text style={[styles.space, styles.textDesc, stylesFonts.regular]}>• To provide affordable laboratory testing services without compromising on quality.</Text>
            </Fragment>
          </View>

          <View style={[styles.headerTitle,styles.space8, styles.columnStyle]}>
            <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>Who We Are</Text>
              <View>
              <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>We specialize in a wide range of diagnostic tests, including:</Text>
    
                <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>✅ Biochemistry</Text>
                <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>✅ Haematology</Text>
                <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>✅ Microbiology</Text>
                <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>✅ Clinical Pathology</Text>
                <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>✅ Histopathology</Text>
                <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>✅ Ocular Pathology (Exclusive Service in Ahmedabad)</Text>
                
                <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>
                  We take pride in our ability to diagnose a large number of ocular diseases, making us pioneers in specialized eye pathology services.
                </Text>
              </View>  
            </View>    

            <View style={[styles.headerTitle,styles.space8, styles.columnStyle]}>
             <Text style={[styles.space, styles.textLab, stylesFonts.bold]}>Our Location & Services</Text>
             <Fragment>
              <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>📍 First Floor, Aishwarya Complex, Maninagar, Ahmedabad</Text>
              <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>🕒 Laboratory Timings: As per operational hours</Text>
              <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>🏡 Home Sample Collection: Available with prior appointment</Text>
              <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>📩 Report Delivery: Via fax, email, or courier</Text>
              <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>📍 Collection Centre: Aishwarya Complex, Jawahar Chowk - Isanpur Road, Maninagar</Text>
              <Text style={[styles.space8, styles.textDesc, stylesFonts.regular]}>📊 Same-day report availability</Text>
             </Fragment>
          </View>    
       </ScrollView>
     </View>
    </SafeAreaView>
  );
};

export default Aboutus;