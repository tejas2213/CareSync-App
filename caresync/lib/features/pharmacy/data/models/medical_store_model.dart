// class MedicalStoresModel{
//   String title;
//   String address;
//   String image;
//   String phoneNo;

//   MedicalStoresModel({required this.title, required this.address, required this.image, required this.phoneNo});

//   Map<String, dynamic> toMap() {
//     return {
//       'title':title,
//       'address':address,
//       'phoneNo':phoneNo,
//       'image':image,
//     };
//   }
// }

class MedicalStoresModel {
  final String id;
  final String title;
  final String address;
  final String phoneNo;
  final String image;
  final List<String> categoryImages; // New field

  MedicalStoresModel({
    required this.id,
    this.title = '',
    this.address = '',
    this.phoneNo = '',
    this.image = '',
    this.categoryImages = const [], required List<String> categories,
  });
}
