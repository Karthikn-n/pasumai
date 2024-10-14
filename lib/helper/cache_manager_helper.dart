import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerHelper {
  CacheManagerHelper._cacheManagerConstructor();

  static CacheManager cacheIt({
    required String key,
    int? maxNrOfCacheObjects, 
    Duration? duration
  }){
    return CacheManager(
      Config(
        "#$key",
        repo: JsonCacheInfoRepository(databaseName: "#$key"),
        maxNrOfCacheObjects: maxNrOfCacheObjects ?? 10,
        fileService: HttpFileService(),
        stalePeriod: duration ?? const Duration(days: 5)
      )
    );
  }
}