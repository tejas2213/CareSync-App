import 'package:caresync/features/ayurveda/data/models/ayurveda_item_model.dart';

abstract class AyurvedaRepository {
  Future<List<AyurvedaItemModel>> getAyurvedaItems();
}
