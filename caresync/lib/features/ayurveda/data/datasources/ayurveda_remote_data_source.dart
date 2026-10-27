import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:caresync/features/ayurveda/data/models/ayurveda_item_model.dart';

abstract class AyurvedaRemoteDataSource {
  Future<List<AyurvedaItemModel>> fetchAyurvedaItems();
}

class AyurvedaRemoteDataSourceImpl implements AyurvedaRemoteDataSource {
  final FirebaseFirestore _firestore;

  AyurvedaRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String?> _downloadAndSaveImage(String imageUrl, String id) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$id.jpg';
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      debugPrint("Error downloading image: $e");
    }
    return null;
  }

  @override
  Future<List<AyurvedaItemModel>> fetchAyurvedaItems() async {
    final querySnapshot = await _firestore
        .collection('Ayurveda')
        .orderBy('createdAt', descending: true)
        .get();

    final List<AyurvedaItemModel> items = [];
    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final id = doc.id;
      final name = data['name']?.toString() ?? '';
      final description = data['description']?.toString() ?? '';
      final imageUrl = data['image']?.toString() ?? '';

      final localImagePath = await _downloadAndSaveImage(imageUrl, id);
      items.add(AyurvedaItemModel(
        id: id,
        name: name,
        description: description,
        imagePath: localImagePath ?? '',
      ));
    }
    return items;
  }
}
