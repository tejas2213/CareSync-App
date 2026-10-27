import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  //final String category;
  final String storeId;
  final String categoryName;

  const ProductScreen({super.key,  required this.storeId, required this.categoryName});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class Product {
  String name;
  double price;
  double mrp;
  String? imageUrl;
  bool isSelected;

  Product({
    required this.name,
    required this.price,
    required this.mrp,
    this.imageUrl,
    this.isSelected = false,
  });
}

class _ProductScreenState extends State<ProductScreen> {
  late List<Product> products;
  List<Product> selectedProducts = [];
  final ImagePicker _picker = ImagePicker();
  bool isSaving = false;

  final Map<String, List<Product>> predefinedProductCategories = {
    'Baby Care': [
      Product(
        name: 'Pampers Baby Dry Pants (M) 20',
        price: 369.00,
        mrp: 00.00,
      ),
      Product(
        name: "Dexolac Stage 2 (After 6 Months) Powder 400 gm (Refill Pack)",
        price: 460.00,
        mrp: 00.00,
      ),
      Product(
        name: "Johnson's Baby Cream 100 gm",
        price: 180.50,
        mrp: 190.00,
      ),
      Product(
        name: "Johnson's Baby Skincare Wipes 72's",
        price: 140.00,
        mrp: 280.00,
      ),
      Product(
        name:
            "Nestle Cerelac Stage 4 (12 Months+) Powder 300 gm- Multigrain & Fruits (Refill Pack)",
        price: 330.00,
        mrp: 00.00,
      ),
      Product(
        name: "Mothercare Flexi Straw Toddler Cup - Blue",
        price: 509.15,
        mrp: 599.00,
      ),
      Product(
        name: "Nestle Nan Pro 1 (Upto 6 Months) Powder 400 gm (Refill Pack)",
        price: 825.00,
        mrp: 0.00,
      ),
      Product(
        name: "Pampers Active Baby (XL) 32's",
        price: 999.00,
        mrp: 0.00,
      ),
    ],
    'Cough & Cold': [
      Product(
        name: 'Vicks Vaporub - 25 ml',
        price: 104.64,
        mrp: 109.00,
      ),
      Product(
        name: "Cofsils Lozenges - Orange 10's",
        price: 26.81,
        mrp: 35.00,
      ),
      Product(
        name: "Himalaya Koflet Syrup - 100ml",
        price: 105.8,
        mrp: 115.00,
      ),
      Product(
        name: "Vicks Vaporub 5ml Relief From Cold Cough Headache And Body Pain",
        price: 22.5,
        mrp: 25,
      ),
      Product(
        name: "Vicks Inhaler Keychain Pack Of 1",
        price: 67.62,
        mrp: 69.00,
      ),
      Product(
        name: "Koflet Sf Ginger Mint Flavour Strip Of 6 Lozenges",
        price: 34.2,
        mrp: 36.00,
      ),
      Product(
        name: "Cofsils Naturals Cough Syrup Bottle 100 Ml",
        price: 67.5,
        mrp: 90.00,
      ),
      Product(
        name: "Naselin Nasal Spray Bottle Of 10 Ml",
        price: 85.93,
        mrp: 92.4,
      ),
    ],
    'Orthopaedics': [
      Product(
        name: 'Tynor R.O.M. Knee Brace 37 cm x 55 cm (UN) (D 10)',
        price: 2184.0,
        mrp: 2730.0,
      ),
      Product(
        name: "Sahyog Wellness Hot Water Bottle/Bag - Green",
        price: 255.00,
        mrp: 300,
      ),
      Product(
        name: "Truuth Ankle Support (M)",
        price: 91.77,
        mrp: 399,
      ),
      Product(
        name: "Tynor Taylor's Brace Long (UN) (A 13)",
        price: 2172.00,
        mrp: 2715,
      ),
      Product(
        name:
            "Tynor Contoured Cervical Pillow - Grey (One Size Fits All) (B 19)",
        price: 1574.40,
        mrp: 1640,
      ),
      Product(
        name: "Tynor Walker Boot Air (M) (D 51)",
        price: 3160.00,
        mrp: 3950,
      ),
      Product(
        name: "Vissco Medip Walker Plain",
        price: 1402.33,
        mrp: 1921,
      ),
      Product(
        name: "Entros Height Adjustable Commode (EHS-696)",
        price: 5127.74,
        mrp: 6178,
      ),
    ],
    'Pain Relief': [
      Product(
        name: 'Volini Gel   -   75gm',
        price: 225.25,
        mrp: 265.00,
      ),
      Product(
        name: "Moov Spray Pain Relief Specialist 80 gm",
        price: 300.00,
        mrp: 329.00,
      ),
      Product(
        name: "Iodex Body Pain Expert 40 gm",
        price: 179.64,
        mrp: 180.00,
      ),
      Product(
        name: "Disprin Regular Effervescent Tablet 10'S",
        price: 11.20,
        mrp: 15.00,
      ),
      Product(
        name: "Moov Pain Relief Specialist Cream 50 gm",
        price: 221.18,
        mrp: 225.00,
      ),
      Product(
        name: "Saridon Advance Tablets for 5 in 1 Pain Relief 10's",
        price: 48.23,
        mrp: 53.00,
      ),
      Product(
        name: "Tiger Balm Ointment - Red 9 ml",
        price: 48.02,
        mrp: 49.00,
      ),
      Product(
        name: "Amrutanjan Strong Pain Balm - Headache and Body Pain 50 ml",
        price: 108.00,
        mrp: 135.00,
      ),
    ],
    'Skin Care': [
      Product(
        name: 'Mamaearth Ubtan Face Scrub 100 gm',
        price: 288.27,
        mrp: 349.00,
      ),
      Product(
        name: "Olay Moisturiser All Day Moisturising Cream 100 gm",
        price: 549.00,
        mrp: 555,
      ),
      Product(
        name: "VLCC Walnut Face Scrub 80 gm",
        price: 198.00,
        mrp: 220,
      ),
      Product(
        name: "Gubb Compressed Towels for Face - 30 Pcs 1's",
        price: 216.75,
        mrp: 255,
      ),
      Product(
        name: "Evver Anti-Aging Anti-Oxidant Face Serum C 25 ml",
        price: 1424.05,
        mrp: 1499,
      ),
      Product(
        name:
            "Plum Bright Years Restorative Overnight Anti-Aging Face Moisturizer Cream - 50 ml",
        price: 990.00,
        mrp: 1125,
      ),
      Product(
        name: "VLCC New Papaya Fruit Facial Kit 60gm",
        price: 252.00,
        mrp: 315,
      ),
      Product(
        name: "Lotus Herbals Safe Sun 3 100 Gm",
        price: 422.40,
        mrp: 480,
      ),
    ],
    'Ayurvedic': [
      Product(
        name: 'Kapiva Triphala Juice 1 litre',
        price: 249.07,
        mrp: 299.00,
      ),
      Product(
        name: "Himalaya Evecare Capsule 30's",
        price: 166.25,
        mrp: 175.00,
      ),
      Product(
        name: "Himalaya Pilex forte Ointment 30 gm",
        price: 116.25,
        mrp: 125.00,
      ),
      Product(
        name: "Patanjali Honey 500 gm",
        price: 205.80,
        mrp: 210.00,
      ),
      Product(
        name: "Dabur Chyawanprash Awaleha 950 gm",
        price: 359.45,
        mrp: 395.00,
      ),
      Product(
        name: "Dr.Juneja's Petsaffa Natural Laxative Granules 60 gm",
        price: 49.68,
        mrp: 54.00,
      ),
      Product(
        name: "Kapiva Wheat Grass Juice 1 ltr",
        price: 449.10,
        mrp: 499.00,
      ),
      Product(
        name: "Pankajakasthuri Breathe Easy Granules 400 gm",
        price: 325.28,
        mrp: 380.00,
      ),
    ],
    'Vitamins': [
      Product(
        name: 'Neuherbs True Vitamin Tablets 60',
        price: 602.33,
        mrp: 899.00,
      ),
      Product(
        name:
            "Swisse Ultiboost Odourless High Strength Wild Fish Oil Capsule 200's",
        price: 1949.25,
        mrp: 0.0,
      ),
      Product(
        name: "Supradyn Daily Multivitamin Tablet with Minerals 15's",
        price: 60.38,
        mrp: 66.35,
      ),
      Product(
        name:
            "Pro360 Ortho Veg Bone and Joint Support Health Supplement Protein Powder 250 g",
        price: 449.00,
        mrp: 525.00,
      ),
      Product(
        name: "Revital H Capsule - Men 30's",
        price: 280.50,
        mrp: 330.00,
      ),
      Product(
        name: "Neuherbs Ashwagandha 1000 Plus Tablets 60's",
        price: 349.30,
        mrp: 499.00,
      ),
      Product(
        name:
            "HealthVit Fitness ZMA (Zinc,Magnesium & Vitamin B6) Capsules 90's",
        price: 946.00,
        mrp: 1100.00,
      ),
      Product(
        name: "Inlife Magnesium Glycinate 1100 mg Veg Capsule 120's",
        price: 749.38,
        mrp: 1199.00,
      ),
    ],
    'Fitness': [
      Product(
        name:
            'Optimum Nutrition (ON) 100% Whey Gold Standard Powder - Double Rich Chocolate 5 lb',
        price: 7451,
        mrp: 8099,
      ),
      Product(
        name: "INLIFE Hepstan Protein Powder - Vanilla Flavour 300 gm",
        price: 602.33,
        mrp: 899.00,
      ),
      Product(
        name: "Endura Mass Weight Gain Powder - Chocolate Flavour 500 gm",
        price: 611.10,
        mrp: 679.00,
      ),
      Product(
        name: "MuscleXP PRO XP Gym Shaker - Black 700 ml",
        price: 299.40,
        mrp: 499.00,
      ),
      Product(
        name:
            "GNC Pro Performance 100% Whey Protein Powder - Vanilla Cream 1.81 kg",
        price: 4574,
        mrp: 7499,
      ),
      Product(
        name: "Penta Sure HP 100% Whey Protein Banana & Vanilla Flavour 1 kg",
        price: 2739,
        mrp: 3468,
      ),
      Product(
        name: "Pro360 Gold Whey 100% Protein Powder - Chocolate Flavour 1 kg",
        price: 2379,
        mrp: 2799,
      ),
      Product(
        name: "Vitaminhaat Caffeine Pro-Lean Series 200 mg Capsule 100's",
        price: 649.35,
        mrp: 999,
      ),
    ],
    'First Aid': [
      Product(
        name: 'St Johns Biker Care First Aid Kit Pouch (SJF BCK)',
        price: 2790.00,
        mrp: 3000.00,
      ),
      Product(
        name: "Hindustan First Aid Kit - Type V 1's",
        price: 861.00,
        mrp: 1050.00,
      ),
      Product(
        name: "Cure Tape Kinesiology - Pink 5m",
        price: 1250.00,
        mrp: 0.00,
      ),
      Product(
        name: "Dr. Morepen Aid Adhesive Band Aid 100's",
        price: 275.00,
        mrp: 0.00,
      ),
      Product(
        name: "St.Johns Multi Purpose Kit In Vinyl Box - Large (SJF V1)",
        price: 1395.00,
        mrp: 1500.00,
      ),
      Product(
        name: "Vinodine Povidone-Iodine Anti-Septic Germicidal Spray 75gm",
        price: 200.00,
        mrp: 250.00,
      ),
      Product(
        name: "St Johns Safe Home First Aid Kit Plastic Box (SJF SHK)",
        price: 1875.00,
        mrp: 2500.00,
      ),
      Product(
        name: "St Johns Workplace First Aid Kit Plastic Box - Medium (SJF P4)",
        price: 1104.00,
        mrp: 1200.00,
      ),
    ],
    'General Discomfort': [
      Product(
        name: 'Digene Fizz Powder - Orange Flavour 5 gm',
        price: 21.95,
        mrp: 0.00,
      ),
      Product(
        name: "Digene Acidity & Gas Relief Gel - Mint Flavour 450 ml",
        price: 224.26,
        mrp: 263.83,
      ),
      Product(
        name: "Cremaffin Constipation Relief Liquid - Mixed Fruit 450ml",
        price: 323.66,
        mrp: 372.02,
      ),
      Product(
        name: "Digene Fizz Powder - Lemon Flavour 5 gm",
        price: 8.00,
        mrp: 0.00,
      ),
      Product(
        name: "Eno Fruit Salt Powder - Regular Flavour 100 gm",
        price: 177.97,
        mrp: 185.00,
      ),
      Product(
        name: "Gaviscon Liquid - Peppermint Flavor 150 ml",
        price: 176.28,
        mrp: 178.60,
      ),
      Product(
        name: "Eno Cooling Cool Lemon & Cool Mint Flavour (Pack of 30 x 5 gm)",
        price: 240.00,
        mrp: 0.00,
      ),
      Product(
        name: "Eno Fruit Salt Powder - Orange Flavour 100 gm",
        price: 168.35,
        mrp: 175.00,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    products = predefinedProductCategories[widget.categoryName] ?? [];
  }

  void _addProduct() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController mrpController = TextEditingController();
    File? selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: mrpController,
                  decoration: const InputDecoration(labelText: 'MRP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      selectedImage = File(pickedFile.path);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Choose Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newProduct = Product(
                  name: nameController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  mrp: double.tryParse(mrpController.text) ?? 0.0,
                  imageUrl: selectedImage?.path,
                );
                setState(() {
                  products.add(newProduct);
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editProduct(Product product) {
    TextEditingController nameController =
        TextEditingController(text: product.name);
    TextEditingController priceController =
        TextEditingController(text: product.price.toString());
    TextEditingController mrpController =
        TextEditingController(text: product.mrp.toString());
    File? selectedImage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: mrpController,
                  decoration: const InputDecoration(labelText: 'MRP'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      selectedImage = File(pickedFile.path);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Choose Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  product.name = nameController.text;
                  product.price = double.tryParse(priceController.text) ?? 0.0;
                  product.mrp = double.tryParse(mrpController.text) ?? 0.0;
                  if (selectedImage != null) {
                    product.imageUrl = selectedImage!.path;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(Product product) {
    setState(() {
      products.remove(product);
    });
  }

  Future<void> _saveSelectedProducts() async {
    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No products selected to save')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    for (var product in selectedProducts) {
      String? imageUrl;
      if (product.imageUrl != null) {
        final file = File(product.imageUrl!);
        final ref = storage.ref().child(
            'CareSync/medical_stores/${widget.storeId}/categories/${widget.categoryName}/products/${DateTime.now().toIso8601String()}_${product.name}.jpg');
        final uploadTask = await ref.putFile(file);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }
      await firestore
          .collection(
              'Medical Stores/${widget.storeId}/categories/${widget.categoryName}/products')
          .add({
        'name': product.name,
        'price': product.price,
        'mrp': product.mrp,
        'imageUrl': imageUrl,
        'category': widget.categoryName,
      });
    }

    setState(() {
      isSaving = false;
      selectedProducts.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Selected products saved successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
             decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
            colors: [
              Color.fromRGBO(97, 206, 255, 1),
              Colors.white,
              Colors.white,
              Color.fromRGBO(14, 190, 126, 1),
            ],
          ),
        ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: screenWidth * 0.1,
                        width: screenWidth * 0.1,
                       decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Colors.transparent,
                          border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 1),
                              width: 1)),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                      ),
                    ),
                    Text(
                      widget.categoryName,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.09),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Container(
                          //height: 150,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black87.withOpacity(0.5),
                                offset: const Offset(0, 4),
                                blurRadius: 8.0,
                                //spreadRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              product.imageUrl != null
                                  ? Image.file(File(product.imageUrl!),
                                      width: 50, height: 50)
                                  : const Icon(Icons.image, size: 50),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 22, 5, 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Price: \$${product.price}'),
                                      Text('MRP: \$${product.mrp}'),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: product.isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        product.isSelected = value ?? false;
                                        if (product.isSelected) {
                                          selectedProducts.add(product);
                                        } else {
                                          selectedProducts.remove(product);
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () => _editProduct(product),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteProduct(product),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ],
                          ));
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isSaving ? null : _saveSelectedProducts,
                  icon: const Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  label: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Save Selected Products',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {_addProduct();},
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add More Products',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
