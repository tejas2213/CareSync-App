// Route name constants — single source of truth for all named routes.
class RouteNames {
  RouteNames._();

  // Onboarding
  static const String splash = '/';
  static const String landing = '/landing';

  // Authentication
  static const String patientSignIn = '/auth/patient/sign-in';
  static const String patientSignUp = '/auth/patient/sign-up';
  static const String doctorSignIn = '/auth/doctor/sign-in';
  static const String doctorSignUp = '/auth/doctor/sign-up';
  static const String adminSignIn = '/auth/admin/sign-in';

  // Patient
  static const String patientHome = '/patient/home';
  static const String patientProfile = '/patient/profile';

  // Doctor
  static const String doctorHome = '/doctor/home';
  static const String doctorProfile = '/doctor/profile';

  // Admin
  static const String adminHome = '/admin/home';

  // Appointments
  static const String bookAppointment = '/appointments/book';
  static const String myAppointments = '/appointments/mine';
  static const String selectSlot = '/appointments/select-slot';

  // Blood Donation
  static const String bloodCard = '/blood-donation/card';
  static const String fillBloodForm = '/blood-donation/fill-form';
  static const String myBlood = '/blood-donation/my-blood';

  // Doctor Speciality
  static const String specialisation = '/speciality';
  static const String doctorsList = '/speciality/doctors';

  // Medical Records
  static const String allRecords = '/medical-records';
  static const String medicalRecordUpload = '/medical-records/upload';

  // Ambulance
  static const String ambulanceHome = '/ambulance';
  static const String ambulanceList = '/ambulance/list';
  static const String ambulanceDetails = '/ambulance/details';
  static const String myAmbulanceBookings = '/ambulance/my-bookings';

  // Pharmacy
  static const String medicalStore = '/pharmacy';
  static const String medicineCategories = '/pharmacy/categories';
  static const String products = '/pharmacy/products';
  static const String cart = '/pharmacy/cart';
  static const String orders = '/pharmacy/orders';
  static const String wishlist = '/pharmacy/wishlist';

  // Ayurveda
  static const String ayurveda = '/ayurveda';
  static const String ayurvedaDetail = '/ayurveda/detail';

  // Chat
  static const String chat = '/chat';

}
