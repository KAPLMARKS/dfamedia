import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
abstract class StoryData with _$StoryData {
  const factory StoryData({
    required String id,
    required String previewImage,
    required bool viewed,
    required String title,
  }) = _StoryData;

  factory StoryData.fromJson(Map<String, dynamic> json) => _$StoryDataFromJson(json);
}
