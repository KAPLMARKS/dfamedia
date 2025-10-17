import 'package:freezed_annotation/freezed_annotation.dart';

part 'banner.freezed.dart';
part 'banner.g.dart';

@freezed
abstract class BannerData with _$BannerData {
  const factory BannerData({
    required String id,
    required String image,
  }) = _BannerData;


  factory BannerData.fromJson(Map<String, dynamic> json) => _$BannerDataFromJson(json);
}
