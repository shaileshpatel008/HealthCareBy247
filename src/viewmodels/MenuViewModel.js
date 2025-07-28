import { MenuModel } from "../models/MenuModel";
import images from "../utils/images"; // Importing images

export const useMenuViewModel = () => {
  const menuData = [
    new MenuModel("Home", images.menuHome, "HomeDrawer"),
    new MenuModel("Book Test", images.menuBook_a_Test, "BookTest"),
    new MenuModel("Book Package", images.menuBook_a_Package, "BookPackage"),
    new MenuModel("Book Visit", images.menuBook_a_Visit, "BookAVisit"),
    new MenuModel("Facilities", images.menuFacilities, "Facilities"),
    new MenuModel("Instrument", images.menuInstrument, "Instrument"),
    new MenuModel("About us", images.menuAbout_us, "AboutUs"),
    new MenuModel("Contact us", images.menuContact_us, "ContactUs"),
  ];

  return { menuData };
};