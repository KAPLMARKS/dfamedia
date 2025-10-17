import 'dart:convert';
import 'package:dfamedia/features/home/domain/models/banner.dart';
import 'package:dfamedia/features/home/domain/models/good.dart';
import 'package:http/http.dart' as http;
import 'package:dfamedia/features/home/data/services/service.dart';
import 'package:dfamedia/features/home/domain/models/story.dart';
import 'package:dfamedia/features/home/domain/models/result.dart';

class DfaMediaService implements Service {
  static const String _baseUrl = 'https://bxtest.dfa-media.ru/udachny';
  
  @override
  Future<Result<List<StoryData>>> getStories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/story.json'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return Result.failure('Failed to load stories: ${response.statusCode}', response.statusCode);
      }

      // Успешный ответ
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> storiesJson = jsonData['story'] ?? [];
      
      final stories = storiesJson.map((storyJson) {
        return StoryData.fromJson({
          'id': storyJson['id'].toString(),
          'previewImage': storyJson['preview_image'] ?? '',
          'viewed': storyJson['viewed'] ?? false,
          'title': storyJson['title'] ?? '',
        });
      }).toList();
      
      return Result.success(stories);
    } catch (e) {
      return Result.failure('Network error: $e');
    }
  }

  @override
  Future<Result<List<BannerData>>> getBanners() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/banners.json'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return Result.failure('Failed to load banners: ${response.statusCode}', response.statusCode);
      }

      // Успешный ответ
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> bannersJson = jsonData['banners'] ?? [];
      
      final banners = bannersJson.map((bannerJson) {
        return BannerData.fromJson({
          'id': bannerJson['id'].toString(),
          'image': bannerJson['image'] ?? '',
        });
      }).toList();
      
      return Result.success(banners);
    } catch (e) {
      return Result.failure('Network error: $e');
    }
  }

  @override
  Future<Result<List<GoodData>>> getGoods() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products.json'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        return Result.failure('Failed to load products: ${response.statusCode}', response.statusCode);
      }

      // Успешный ответ
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> productsJson = jsonData['products'] ?? [];
      
      final products = productsJson
          .where((productJson) => productJson != null)
          .map((productJson) {
            try {
              return GoodData.fromJson({
              'id': (productJson['id'] ?? '').toString(),
              'title': productJson['title'] ?? '',
              'image': productJson['image'] ?? '',
              'price': productJson['price'] ?? 0,
              'unitText': productJson['unit_text'] ?? '',
              });
            } catch (e) {
              return null;
            }
          })
          .where((product) => product != null)
          .cast<GoodData>()
          .toList();
      
      return Result.success(products);
    } catch (e) {
      return Result.failure('Network error: $e');
    }
  }
}
