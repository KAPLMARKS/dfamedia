import 'package:freezed_annotation/freezed_annotation.dart';

part 'good.freezed.dart';
part 'good.g.dart';

@freezed
abstract class GoodData with _$GoodData {
  const factory GoodData({
    required String id,
    required String title,
    required String image,
    required int price,
    required String unitText,
  }) = _GoodData;

  factory GoodData.fromJson(Map<String, dynamic> json) => _$GoodDataFromJson(json);
}
