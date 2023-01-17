import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slow/features/home/domain/tag_model.dart';

part 'message_model.g.dart';

@JsonSerializable(createToJson: false)
class MessageModel {
  final String title;
  final List<TagModel> tags;
  final List<String> filePaths;

  MessageModel({
    required this.title,
    required this.tags,
    required this.filePaths,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}
