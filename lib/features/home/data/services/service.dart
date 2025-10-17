import 'package:dfamedia/features/home/domain/models/banner.dart';
import 'package:dfamedia/features/home/domain/models/good.dart';
import 'package:dfamedia/features/home/domain/models/story.dart';
import 'package:dfamedia/features/home/domain/models/result.dart';

abstract interface class Service {
  const Service();

  Future<Result<List<BannerData>>> getBanners();

  Future<Result<List<GoodData>>> getGoods();

  Future<Result<List<StoryData>>> getStories();
}
