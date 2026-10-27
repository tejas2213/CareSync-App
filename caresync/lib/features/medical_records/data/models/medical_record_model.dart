import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecordModel {
  final String id;
  final String type; // 'file' or 'image'
  final String fileName;
  final String url;
  final DateTime? timestamp;

  MedicalRecordModel({
    required this.id,
    required this.type,
    required this.fileName,
    required this.url,
    this.timestamp,
  });

  factory MedicalRecordModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    DateTime? time;
    if (data['timestamp'] != null) {
      if (data['timestamp'] is Timestamp) {
        time = (data['timestamp'] as Timestamp).toDate();
      }
    }

    return MedicalRecordModel(
      id: doc.id,
      type: data['type']?.toString() ?? 'file',
      fileName: data['file_name']?.toString() ?? '',
      url: data['url']?.toString() ?? '',
      timestamp: time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'file_name': fileName,
      'url': url,
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp!)
          : FieldValue.serverTimestamp(),
    };
  }
}
