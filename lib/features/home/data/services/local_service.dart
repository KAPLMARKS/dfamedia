import 'package:dfamedia/features/home/domain/models/banner.dart';
import 'package:dfamedia/features/home/domain/models/good.dart';
import 'package:dfamedia/features/home/domain/models/story.dart';
import 'package:dfamedia/features/home/domain/models/result.dart';
import 'package:dfamedia/core/services/database_service.dart';

class LocalService {
  final DatabaseService _databaseService;

  LocalService(this._databaseService);

  // Истории
  Future<Result<List<StoryData>>> getStories() async {
    try {
      final stories = await _databaseService.getCachedStories();
      return Result.success(stories);
    } catch (e) {
      return Result.failure('Ошибка получения историй из кэша: $e');
    }
  }

  Future<void> cacheStories(List<StoryData> stories) async {
    await _databaseService.cacheStories(stories);
  }

  // Баннеры
  Future<Result<List<BannerData>>> getBanners() async {
    try {
      final banners = await _databaseService.getCachedBanners();
      return Result.success(banners);
    } catch (e) {
      return Result.failure('Ошибка получения баннеров из кэша: $e');
    }
  }

  Future<void> cacheBanners(List<BannerData> banners) async {
    await _databaseService.cacheBanners(banners);
  }

  // Товары
  Future<Result<List<GoodData>>> getGoods() async {
    try {
      final goods = await _databaseService.getCachedGoods();
      return Result.success(goods);
    } catch (e) {
      return Result.failure('Ошибка получения товаров из кэша: $e');
    }
  }

  Future<void> cacheGoods(List<GoodData> goods) async {
    await _databaseService.cacheGoods(goods);
  }

  // Очистка кэша
  Future<void> clearCache() async {
    await _databaseService.clearCache();
  }
}
