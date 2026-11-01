# Health Care Lab — Flutter app

Flutter + GetX rebuild of the React Native app in this repository (`../`),
using the approved redesign ("Health Care Lab — Flutter App Redesign" canvas).
Same backend (`https://healthcare24x7.com/api/`), same flows, new UI and motion.

## Run

```bash
cd flutter_app
flutter pub get
flutter run                 # debug on a connected phone/emulator
flutter build apk --release # android/app/... → build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle     # .aab for Play Console
```

Flutter 3.47 / Dart 3.13 or newer.

## Installs next to the React Native app

| | React Native (live) | This Flutter app |
|---|---|---|
| Android applicationId | `com.healthcarelab` | `com.healthcarelab.flutter` |
| iOS bundle id | `in.healthcare24x7.pathlab` | `com.healthcarelab.flutter` |
| Launcher name | Health Care Lab | HC Lab Flutter |
| Version | 1.0.10 (11) | 2.0.0 (12) |

Different ids, so both stay installed on the same phone.

**To ship this as the update to the Play listing later:** set
`applicationId = "com.healthcarelab"` in `android/app/build.gradle.kts`, set
`android:label="Health Care Lab"` in `AndroidManifest.xml`, keep the version
code above the live one, and sign with the same upload key (below).

## Release signing

`android/key.properties` (git-ignored) points release signing at a keystore.
Using the React Native app's key keeps one upload key for both:

```properties
storeFile=../../../android/app/healthcare.jks
storePassword=…
keyAlias=healthcare-key
keyPassword=…
```

Without the file, release builds are signed with the debug key (fine for
testing, not for Play).

## Structure (same layout as DrCardioCloudFlutterLatest)

```
lib/
  main.dart                 app start: storage, connectivity, cart, config; offline overlay
  core/
    constants/              api_constants (every endpoint), app_constants, app_assets
    network/                dio_client, api_exception (plain-language errors)
    services/               storage, connectivity, cart, config, launcher (call/WhatsApp/
                            email/maps/share), location, photo_picker, update
    utils/formatters.dart   ₹ formatting, title-casing API names
    widgets/                app_dialog (success/error/warning/info), app_toast, pressable,
                            animated_check, shake, app_text_field, picker_sheet,
                            prescription_strip, fly_to_cart, cart_icon_button, cart_bar,
                            state_views (skeleton/empty/error), offline_view, update_sheet…
  data/
    models/                 lab_test, package, cart_item, booking_request, lookup_models
    datasources/remote/     lab_remote_datasource (all GET/POST calls)
    repositories/           lab_repository (in-memory catalogue cache)
  modules/<feature>/        bindings / controllers / views / widgets
    splash, home (shell + dashboard + side menu + floating nav), tests, packages,
    package_detail, cart, booking, booking_success, upload_prescription,
    contact, facilities, about
  routes/                   app_routes, app_pages
  theme/                    app_colors, app_text_styles, app_theme
```

## Every React Native flow → where it lives here

| React Native | Flutter |
|---|---|
| `App.js` `sysConfig.php` → ConfigContext | `ConfigService` (cached, refreshed on launch) |
| `App.js` VersionCheck → blocking `UpdateModal` | `UpdateService` → non-dismissable `UpdateSheet` (Play in-app update / App Store lookup) |
| `useNetworkStatus` → `NoInternetScreen` | `ConnectivityService` → `OfflineView` overlay with "Try again" |
| `CartContext` (+ AsyncStorage `@cart_items`) | `CartService` (+ GetStorage, same key) |
| Drawer `SideMenu` (lab name → website, email → mailto, 8 entries) | `home/widgets/side_menu.dart` (same + Upload prescription, My cart, Share, Exit) |
| Tab bar Home / Contact Us / Call Us / WhatsApp (with confirm prompts) | Floating nav Home / Tests / Packages / Cart / Contact; Call + WhatsApp on Home and Contact, same confirm prompts |
| Home: `newsletter.php` carousel (autoplay 3 s, `param == Y` → packages) | `DashboardController` + `_BannerCarousel` |
| Home: Book Package / Test / Visit / Upload Prescription tiles | Bento quick actions + prescription card |
| Home back button → "Exit Application?" | `HomeController.handleBack` → "Leave the app?" |
| Upload Prescription → photo source sheet → `SubmitPrescriptions` (name, mobile, photos → `onlyPrescription.php`) | `upload_prescription` module, `PhotoSourceSheet`, full-screen preview, remove, add more |
| `BookATest` `reportsinfo.php`, search, add/remove | `tests` module (+ sample-type filter chips, fly-to-cart) |
| `BookAPackges` `packageswithTest.php`, search, add/remove, info → tests modal | `packages` module + `package_detail` screen |
| `MyCartView`: list, remove with confirm, total, empty state, Place Inquiry | `cart` module (+ swipe to remove, MRP / savings summary) |
| `PlaceInquery` (from cart; edits sync the cart) | `booking` module, `BookingMode.cart` |
| `BookAVisit` (independent selection) | `booking` module, `BookingMode.visit` |
| Inquiry fields: name, mobile, email, address 1/2, area, pincode, GPS location, date, time slot (future only today), packages, tests, prescription photos | Same fields, same rules, same `registration.php` multipart body |
| Success alert with inquiry ID → clear cart → Home | `booking_success` screen with the ID, then Home |
| `Contactus`: co-ordinator, `branches.php` accordion, map, call confirm | `contact` module |
| `Aboutus` | `about` module |
| `Facilities` / `Instruments` WebViews | `facilities` module, two tabs, same pages (Instruments zoomable) |

## Animations (motion board)

Splash logo scale-in + pulse rings · page transitions (right-to-left + fade,
300 ms) · staggered list fade-up · tap shrink + haptic · add-to-cart fly + badge
bounce · success tick that draws itself · error shake on invalid fields ·
bottom sheets over a dimmed screen · skeleton shimmer while loading · tab
cross-fade · animated nav pill · toasts sliding up.

## Permissions

Asked when needed, not at launch: location (booking "Use my current
location"), camera / photos (prescription). Each refusal explains what to do
and offers to open Settings.
