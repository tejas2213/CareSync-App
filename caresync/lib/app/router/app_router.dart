
import 'package:caresync/features/admin/presentation/pages/add_ambulance_page.dart';
import 'package:caresync/features/admin/presentation/pages/add_ayurveda_page.dart';
import 'package:caresync/features/admin/presentation/pages/add_categories_page.dart';
import 'package:caresync/features/admin/presentation/pages/add_store_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_ambulances_list_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_ayurveda_list_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_home_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_products_page.dart';
import 'package:caresync/features/admin/presentation/pages/admin_store_list_page.dart';
import 'package:caresync/features/admin/presentation/pages/edit_categories_page.dart';
import 'package:caresync/features/ambulance/presentation/pages/ambulance_details_page.dart';
import 'package:caresync/features/ambulance/presentation/pages/ambulance_home_page.dart';
import 'package:caresync/features/ambulance/presentation/pages/ambulance_list_page.dart';
import 'package:caresync/features/ambulance/presentation/pages/my_ambulance_bookings_page.dart';
import 'package:caresync/features/appointments/presentation/pages/book_appointment_page.dart';
import 'package:caresync/features/appointments/presentation/pages/my_appointments_page.dart';
import 'package:caresync/features/appointments/presentation/pages/select_slot_page.dart';
import 'package:caresync/features/authentication/presentation/pages/admin_sign_in_page.dart';
import 'package:caresync/features/authentication/presentation/pages/doctor_sign_in_page.dart';
import 'package:caresync/features/authentication/presentation/pages/doctor_sign_up_page.dart';
import 'package:caresync/features/authentication/presentation/pages/patient_sign_in_page.dart';
import 'package:caresync/features/authentication/presentation/pages/patient_sign_up_page.dart';
import 'package:caresync/features/ayurveda/presentation/pages/ayurveda_detail_page.dart';
import 'package:caresync/features/ayurveda/presentation/pages/ayurveda_page.dart';
import 'package:caresync/features/blood_donation/presentation/pages/blood_card_page.dart';
import 'package:caresync/features/blood_donation/presentation/pages/fill_blood_form_page.dart';
import 'package:caresync/features/blood_donation/presentation/pages/my_blood_page.dart';
import 'package:caresync/features/chat/presentation/pages/chat_screen_page.dart';
import 'package:caresync/features/doctor_speciality/presentation/pages/doctors_list_page.dart';
import 'package:caresync/features/doctor_speciality/presentation/pages/specialisation_page.dart';
import 'package:caresync/features/doctors/presentation/pages/doctor_home_page.dart';
import 'package:caresync/features/doctors/presentation/pages/doctor_profile_page.dart';
import 'package:caresync/features/medical_records/presentation/pages/all_records_page.dart';
import 'package:caresync/features/medical_records/presentation/pages/medical_record_upload_page.dart';
import 'package:caresync/features/onboarding/presentation/pages/landing_page.dart';
import 'package:caresync/features/onboarding/presentation/pages/splash_page.dart';
import 'package:caresync/features/patients/presentation/pages/patient_home_page.dart';
import 'package:caresync/features/patients/presentation/pages/patient_profile_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/cart_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/medical_store_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/medicine_categories_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/orders_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/products_page.dart';
import 'package:caresync/features/pharmacy/presentation/pages/wishlist_page.dart';
import 'package:flutter/material.dart';
import 'route_names.dart';

/// Central app router using Flutter's built-in Navigator.
///
/// This class provides a single [onGenerateRoute] callback that maps
/// named routes to their corresponding widget pages, preserving all
/// existing navigation flows while providing a centralized route registry.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = (settings.arguments is Map) ? (settings.arguments as Map) : const {};

    switch (settings.name) {
      // ─── Onboarding ───────────────────────────────────────────────────────
      case RouteNames.splash:
        return _build(const SplashScreen(), settings);
      case RouteNames.landing:
        return _build(const LandingPage(), settings);

      // ─── Authentication ───────────────────────────────────────────────────
      case RouteNames.patientSignIn:
        return _build(const PatientSignInPage(), settings);
      case RouteNames.patientSignUp:
        return _build(const PatientSignUpPage(), settings);
      case RouteNames.doctorSignIn:
        return _build(const DoctorSignInPage(), settings);
      case RouteNames.doctorSignUp:
        return _build(const DoctorSignUpPage(), settings);
      case RouteNames.adminSignIn:
        return _build(const AdminSignInPage(), settings);

      // ─── Patient ──────────────────────────────────────────────────────────
      case RouteNames.patientHome:
        return _build(const PatientHomeScreen(), settings);
      case RouteNames.patientProfile:
        return _build(const PatientProfilePage(), settings);

      // ─── Doctor ───────────────────────────────────────────────────────────
      case RouteNames.doctorHome:
        return _build(const DoctorHomeScreen(), settings);
      case RouteNames.doctorProfile:
        return _build(const DoctorProfilePage(), settings);

      // ─── Admin ────────────────────────────────────────────────────────────
      case RouteNames.adminHome:
        return _build(const HomeScreen(), settings);
      case '/admin/add-ambulance':
        return _build(const AddAmbulancePage(), settings);
      case '/admin/add-ayurveda':
        return _build(const AddItemScreen(), settings);
      case '/admin/add-categories':
        return _build(
          AddCategoriesScreen(
            storeId: args['storeId']?.toString() ?? '',
            storeName: args['storeName']?.toString() ?? '',
          ),
          settings,
        );
      case '/admin/add-store':
        return _build(const AddStoreScreen(), settings);
      case '/admin/ambulances':
        return _build(const AmbulancesList(), settings);
      case '/admin/ayurveda':
        return _build(const AyurvedaListScreen(), settings);
      case '/admin/edit-categories':
        return _build(
          EditStoreScreen(
            storeId: args['storeId']?.toString() ?? '',
            storeName: args['storeName']?.toString() ?? '',
          ),
          settings,
        );
      case '/admin/products':
        return _build(
          ProductScreen(
            storeId: args['storeId']?.toString() ?? '',
            categoryName: args['categoryName']?.toString() ?? '',
          ),
          settings,
        );
      case '/admin/stores':
        return _build(const MedicalStoresListScreen(), settings);

      // ─── Appointments ─────────────────────────────────────────────────────
      case RouteNames.bookAppointment:
        return _build(
          BookAppointment(
            doctorName: args['doctorName']?.toString() ?? '',
            clinicName: args['clinicName']?.toString() ?? '',
            specialty: args['specialty']?.toString() ?? '',
            doctorImage: args['doctorImage']?.toString() ?? '',
            doctorId: args['doctorId']?.toString() ?? '',
          ),
          settings,
        );
      case RouteNames.myAppointments:
        return _build(const MyAppointments(), settings);
      case RouteNames.selectSlot:
        return _build(
          SelectTime(
            doctorName: args['doctorName']?.toString() ?? '',
            clinicName: args['clinicName']?.toString() ?? '',
            specialty: args['specialty']?.toString() ?? '',
            doctorImage: args['doctorImage']?.toString() ?? '',
            doctorId: args['doctorId']?.toString() ?? '',
            patientName: args['patientName']?.toString() ?? '',
            number: args['number']?.toString() ?? '',
            selectedDate: args['selectedDate']?.toString() ?? '',
          ),
          settings,
        );

      // ─── Blood Donation ───────────────────────────────────────────────────
      case RouteNames.bloodCard:
        return _build(const BloodDetails(), settings);
      case RouteNames.fillBloodForm:
        return _build(const Bloodgroup(), settings);
      case RouteNames.myBlood:
        return _build(const MyBloodReq(), settings);

      // ─── Doctor Speciality ────────────────────────────────────────────────
      case RouteNames.specialisation:
        return _build(const DoctorCategories(), settings);
      case RouteNames.doctorsList:
        return _build(
          DoctorListScreen(
            drSpeciality: args['drSpeciality']?.toString() ?? '',
            selectedIndex: args['selectedIndex'] is int ? args['selectedIndex'] as int : 0,
          ),
          settings,
        );

      // ─── Medical Records ──────────────────────────────────────────────────
      case RouteNames.allRecords:
        return _build(const AllRecords(), settings);
      case RouteNames.medicalRecordUpload:
        return _build(const RecordScreen1(), settings);

      // ─── Ambulance ────────────────────────────────────────────────────────
      case RouteNames.ambulanceHome:
        return _build(const AmbulanceBookingHome(), settings);
      case RouteNames.ambulanceList:
        return _build(
          AmbulanceListScreen(
            type: args['type']?.toString() ?? '',
          ),
          settings,
        );
      case RouteNames.ambulanceDetails:
        return _build(
          AmbulanceDetailsScreen(
            ambulanceId: args['ambulanceId']?.toString() ?? '',
            ambulanceType: args['ambulanceType']?.toString() ?? '',
          ),
          settings,
        );
      case RouteNames.myAmbulanceBookings:
        return _build(const MyAmbulanceBookingsScreen(), settings);

      // ─── Pharmacy ─────────────────────────────────────────────────────────
      case RouteNames.medicalStore:
        return _build(const MedicalStore(), settings);
      case RouteNames.medicineCategories:
        return _build(
          ProductCategories(
            categoryImages: (args['categoryImages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
            storeId: args['storeId'] ?? '',
          ),
          settings,
        );
      case RouteNames.products:
        return _build(
          ProductsPage(
            categoryName: args['categoryName']?.toString() ?? '',
            storeId: args['storeId'] ?? '',
            patientId: args['patientId']?.toString() ?? '',
          ),
          settings,
        );
      case RouteNames.cart:
        return _build(
          Cart(
            patientId: args['patientId']?.toString() ?? '',
            storeId: args['storeId']?.toString() ?? '',
            onProductChanged: (args['onProductChanged'] as VoidCallback?) ?? () {},
          ),
          settings,
        );
      case RouteNames.orders:
        return _build(
          OrdersPage(
            patientId: args['patientId']?.toString() ?? '',
          ),
          settings,
        );
      case RouteNames.wishlist:
        return _build(
          Wishlist(
            patientId: args['patientId']?.toString() ?? '',
            onProductChanged: (args['onProductChanged'] as VoidCallback?) ?? () {},
          ),
          settings,
        );

      // ─── Ayurveda ─────────────────────────────────────────────────────────
      case RouteNames.ayurveda:
        return _build(const AyurvedaGridScreen(), settings);
      case RouteNames.ayurvedaDetail:
        return _build(
          AyurvedaDetailScreen(
            name: args['name']?.toString() ?? '',
            imagePath: args['imagePath']?.toString() ?? '',
            description: args['description']?.toString() ?? '',
          ),
          settings,
        );

      // ─── Chat ─────────────────────────────────────────────────────────────
      case RouteNames.chat:
        return _build(
          ChatScreen(
            chatData: (args['chatData'] as Map<dynamic, dynamic>?)?.map(
                  (key, value) => MapEntry(key.toString(), value.toString()),
                ) ??
                const {},
          ),
          settings,
        );



      default:
        return _build(
          Scaffold(
            body: Center(
              child: Text(
                'Route not found: ${settings.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute<dynamic> _build(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
