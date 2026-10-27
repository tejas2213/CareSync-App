import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:caresync/features/ayurveda/data/models/ayurveda_item_model.dart';
import 'package:caresync/features/ayurveda/data/repositories/ayurveda_repository_impl.dart';
import 'package:caresync/features/ayurveda/domain/repositories/ayurveda_repository.dart';

final ayurvedaRepositoryProvider = Provider<AyurvedaRepository>((ref) {
  return AyurvedaRepositoryImpl();
});

final ayurvedaItemsFutureProvider =
    FutureProvider.autoDispose<List<AyurvedaItemModel>>((ref) {
  final repository = ref.watch(ayurvedaRepositoryProvider);
  return repository.getAyurvedaItems();
});
