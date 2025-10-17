import 'package:flutter/material.dart';
import '../data/repository.dart';
import '../domain/models/story.dart';
import '../domain/models/banner.dart';
import '../domain/models/good.dart';
import '../domain/models/result.dart';

class HomeWM extends ChangeNotifier {
  final Repository _repository;
  
  // Состояние (бывшая модель)
  List<StoryData> _stories = [];
  List<BannerData> _banners = [];
  List<GoodData> _goods = [];
  bool _isLoading = true;
  String? _errorMessage;

  HomeWM(this._repository) {
    _loadStories();
    _loadBanners();
    _loadGoods();
  }

  // Геттеры для доступа к состоянию
  List<StoryData> get stories => _stories;
  List<BannerData> get banners => _banners;
  List<GoodData> get goods => _goods;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _loadStories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final storiesResult = await _repository.getStories();
    
    switch (storiesResult) {
      case Success(data: final storiesData):
        final filteredStories = storiesData.where((story) {
          return story.title.isNotEmpty && 
                 story.previewImage.isNotEmpty;
        }).toList();
        
        _stories = filteredStories;
        _isLoading = false;
        break;
      case Failure(message: final error):
        _isLoading = false;
        _errorMessage = error;
        break;
    }
    
    notifyListeners();
  }

  Future<void> _loadBanners() async {
    final bannersResult = await _repository.getBanners();
    
    switch (bannersResult) {
      case Success(data: final bannersData):
        _banners = bannersData;
        break;
      case Failure(message: final error):
        // Баннеры не критичны, просто логируем ошибку
        debugPrint('Failed to load banners: $error');
        break;
    }
    
    notifyListeners();
  }

  Future<void> _loadGoods() async {
    final goodsResult = await _repository.getGoods();
    
    switch (goodsResult) {
      case Success(data: final goodsData):
        _goods = goodsData;
        break;
      case Failure(message: final error):
        // Товары не критичны, просто логируем ошибку
        debugPrint('Failed to load goods: $error');
        break;
    }
    
    notifyListeners();
  }

  Future<void> retry() async {
    await _loadStories();
    await _loadBanners();
    await _loadGoods();
  }

  void onStoryTap(StoryData story) {}
}
