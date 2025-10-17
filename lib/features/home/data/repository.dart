import 'package:dfamedia/features/home/domain/models/banner.dart';
import 'package:dfamedia/features/home/domain/models/good.dart';
import 'package:dfamedia/features/home/domain/models/story.dart';
import 'package:dfamedia/features/home/domain/models/result.dart';
import 'package:dfamedia/features/home/data/services/service.dart';
import 'package:dfamedia/features/home/data/services/local_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class Repository {
  Future<Result<List<StoryData>>> getStories();
  Future<Result<List<BannerData>>> getBanners();
  Future<Result<List<GoodData>>> getGoods();
  Future<void> clearCache();
}

class DfaMediaRepository implements Repository {
  final Service _onlineService;
  final LocalService _localService;
  final Connectivity _connectivity = Connectivity();

  DfaMediaRepository(this._onlineService, this._localService);

  Future<bool> _isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult.any((result) => 
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet ||
      result == ConnectivityResult.vpn
    );
  }

  @override
  Future<Result<List<StoryData>>> getStories() async {
    try {
      if (!await _isConnected()) return await _localService.getStories();

      // Есть подключение - получаем из сети и кэшируем
      final result = await _onlineService.getStories();
      return result.when(
        success: (data) async {
          await _localService.cacheStories(data);
          return Result.success(data);
        },
        failure: (message, statusCode) async {
          // Если онлайн не удался, пробуем локальный кэш
          return await _localService.getStories();
        },
      );
    } catch (e) {
      // В случае любой ошибки пробуем получить из кэша
      return await _localService.getStories();
    }
  }

  @override
  Future<Result<List<BannerData>>> getBanners() async {
    try {
      if (!await _isConnected()) return await _localService.getBanners();

      // Есть подключение - получаем из сети и кэшируем
      final result = await _onlineService.getBanners();
      return result.when(
        success: (data) async {
          await _localService.cacheBanners(data);
          return Result.success(data);
        },
        failure: (message, statusCode) async {
          // Если онлайн не удался, пробуем локальный кэш
          return await _localService.getBanners();
        },
      );
    } catch (e) {
      // В случае любой ошибки пробуем получить из кэша
      return await _localService.getBanners();
    }
  }

  @override
  Future<Result<List<GoodData>>> getGoods() async {
    try {
      if (!await _isConnected()) return await _localService.getGoods();

      // Есть подключение - получаем из сети и кэшируем
      final result = await _onlineService.getGoods();
      return result.when(
        success: (data) async {
          await _localService.cacheGoods(data);
          return Result.success(data);
        },
        failure: (message, statusCode) async {
          // Если онлайн не удался, пробуем локальный кэш
          return await _localService.getGoods();
        },
      );
    } catch (e) {
      // В случае любой ошибки пробуем получить из кэша
      return await _localService.getGoods();
    }
  }

  @override
  Future<void> clearCache() async {
    await _localService.clearCache();
  }
}
