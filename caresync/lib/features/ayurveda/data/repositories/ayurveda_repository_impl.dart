import 'package:caresync/features/ayurveda/data/datasources/ayurveda_local_data_source.dart';
import 'package:caresync/features/ayurveda/data/datasources/ayurveda_remote_data_source.dart';
import 'package:caresync/features/ayurveda/data/models/ayurveda_item_model.dart';
import 'package:caresync/features/ayurveda/domain/repositories/ayurveda_repository.dart';

class AyurvedaRepositoryImpl implements AyurvedaRepository {
  final AyurvedaLocalDataSource _localDataSource;
  final AyurvedaRemoteDataSource _remoteDataSource;

  AyurvedaRepositoryImpl({
    AyurvedaLocalDataSource? localDataSource,
    AyurvedaRemoteDataSource? remoteDataSource,
  })  : _localDataSource = localDataSource ?? AyurvedaLocalDataSourceImpl(),
        _remoteDataSource = remoteDataSource ?? AyurvedaRemoteDataSourceImpl();

  @override
  Future<List<AyurvedaItemModel>> getAyurvedaItems() async {
    try {
      final remoteItems = await _remoteDataSource.fetchAyurvedaItems();
      if (remoteItems.isNotEmpty) {
        await _localDataSource.cacheItems(remoteItems);
        return remoteItems;
      }
    } catch (_) {
      // Offline fallback: fall through to local cache
    }

    final localItems = await _localDataSource.getCachedItems();
    return localItems;
  }
}
